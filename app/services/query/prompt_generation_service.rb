module Query
  class PromptGenerationService
    CONTEXT_SEPARATOR = "\n* "
    CONTEXT_SEPARATOR_LENGTH = 4
    MAX_CONTEXT_LENGTH = 500
    
    attr_reader :context, :book, :query

    def initialize(context:, book:, query:)
      @context = context
      @book = book
      @query = query
    end

    def call
      book.prompt_headers.join("\n") + "\n\n" +
      truncated_context + "\n\n" +
      hints.join('\n') + "\n" +
      "Question: #{query} \n" + 
      "Answer:"
    end

    private

    def hints
      hint_types = { 0 => 'Question:', 1 => 'Answer:'}
      book.prompt_hints.each_with_index.map do |hint, idx|
        type =  hint_types[idx % 2]
        "#{type} #{hint}"
      end
    end

    def truncated_context
      text = []
      available_context_length = MAX_CONTEXT_LENGTH
      
      context.each do |ctx|
        content = Page.find(ctx[:page_id]).content
        available_context_length = available_context_length - content.size - CONTEXT_SEPARATOR_LENGTH

        unless available_context_length.positive?
          bound = content.size + available_context_length
          text << content.slice(0, bound)
          text << CONTEXT_SEPARATOR
          break
        end

        text << content
        text << CONTEXT_SEPARATOR
      end

      text.join('')
    end
  end
end