require 'tokenizers'
require 'pdf-reader'
require 'openai'

openai = OpenAI::Client.new

namespace :ingest do
  desc "Ingest pdf file and data"
  task :pdf => :environment do
    

    puts "Initializing pages..."

    pages = []
    pdf_reader = PDF::Reader.new(ARGV[1])
    tokenizer = Tokenizers.from_pretrained('gpt2')

    pdf_reader.pages.each_with_index do |raw_page, page_index|
      page = raw_page.text.gsub(/[^0-9 a-z]{2,}/i, ' ')

      page.split('').each_slice(Page::PAGE_FRAGMENT_SIZE).each_with_index do |chars, slice_idx|
        text = chars.join('')
        token_count = tokenizer.encode(text).tokens.size
        next unless  token_count > 50 && token_count < Page::EMBEDDINGS_MODEL_MAX_TOKENS
        pages << Page.new(content: text, index: page_index, fragment: slice_idx)
      end
    end

    puts "Persisting total #{pages.count} pages..."

    pdf_data = JSON.parse(File.new(ARGV[2]).read)
    book = Book.new(**pdf_data, pages: pages)

    Book.with_session do |session|
      session.start_transaction
      book.save!
      book.pages.each(&:save!)
      session.commit_transaction
    end

    puts "Initializing embeddings..."

    pages.each_slice(20).each do |slice|
      input = slice.map(&:content)
      results = openai.embeddings(parameters: { model: Page::EMBEDDINGS_MODEL, input: input })
      
      results['data'].each do |r|
        idx = r['index'].to_i
        page = slice[idx]
        vector = r['embedding']

        Embedding.create!(
          vector: vector, 
          magnitude: Math.sqrt(vector.reduce(0) {|acc, val| acc + val**2 }),
          page: page, 
          book: book
        )
      end
    end

    puts "Ingestion finished."
  end
end