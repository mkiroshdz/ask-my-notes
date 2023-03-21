require 'tokenizers'
require 'pdf-reader'
require 'openai'

openai = OpenAI::Client.new

namespace :ingest do
  desc "Ingest pdf file and data"
  task :pdf => :environment do
    pdf_reader = PDF::Reader.new(ARGV[1])
    pdf_data = JSON.parse(File.new(ARGV[2]).read)

    tokenizer = Tokenizers.from_pretrained('gpt2')

    puts "Initializing pages..."
    pages = []
    pdf_reader.pages.each_with_index do |raw_page, page_number|
      raw_page.text.split('').each_slice(Page::PAGE_FRAGMENT_SIZE).each_with_index do |chars, order|
        txt = chars.join('')
        token_count = tokenizer.encode(txt).tokens.size
        next unless  token_count > 0 && token_count < Page::EMBEDDINGS_MODEL_MAX_TOKENS

        pages << Page.new(content: txt, number: page_number, fragment: order)
      end
    end

    puts "Initializing embeddings..."
    embeddings = []
    pages.each_slice(20).each do |slice|
      input = slice.map(&:content)
      results = openai.embeddings(parameters: { model: Page::EMBEDDINGS_MODEL, input: input })
      
      results['data'].each do |r|
        idx = r['index'].to_i
        page = slice[idx]
        embeddings << Embedding.new(content: r['embedding'], number: page.number, fragment: page.fragment)
      end
    end

    puts "Persisting - pages: #{pages.count} embeddings: #{embeddings.count}"

    book = Book.new(**pdf_data, pages: pages, embeddings: embeddings)
    Book.with_session do |session|
      session.start_transaction
      book.save!
      book.pages.each(&:save!)
      book.embeddings.each(&:save!)
      session.commit_transaction
    end
    
    puts "Ingestion finished."
  end
end