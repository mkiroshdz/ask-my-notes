require 'openai'

module Books
  class TextSearchService
    QUERIES_MODEL = "text-search-curie-query-001"
    attr_reader :book_id, :query

    def initialize(book_id:, query:)
      @book_id = book_id
      @query = query
    end

    def call
      candidates
        .sort {|a, b| a[:score] <=> b[:score] }
        .reverse
    end

    private 

    def query_vector
      return @query_vector if defined? @query_vector

      result = openai.embeddings(parameters: { model: QUERIES_MODEL, input: query })
      @query_vector = result['data'][0]['embedding']
    end

    def openai
      @openai ||= OpenAI::Client.new
    end

    def candidates
      embeddings.each_with_object([]) do |e, selected|
        score = cosene(e)
        selected << { score: score, page_id: e.page_id } if score > 0.2
      end
    end

    def cosene(embedding)
      vector = embedding.vector
      dot_product = query_vector.zip(vector).reduce(0) { |acc, (a,b)| acc + (a * b) }
      mag = Math.sqrt(query_vector.reduce(0) {|acc, val| acc + val**2 })
      dot_product / (mag * embedding.magnitude)
    end

    def embeddings
      Embedding
        .where(book_id: book_id)
        .sort(number: 1, fragment: 1)
    end
  end
end