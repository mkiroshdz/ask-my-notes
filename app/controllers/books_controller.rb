require 'openai'

class BooksController < ApplicationController
  PROMP_CONTEXT_LENGTH = 500

  def ask
    @book = Book.find_by!(slug: params[:book_id])
    results = completions["choices"].map {|c| c["text"]}
    render json: { prompt: results }
  end

  private

  def completions
    OpenAI::Client.new.completions(
      parameters: {
        model: "text-davinci-003", 
        prompt: prompt, 
        max_tokens: 150, 
        temperature: 0.1
      }
    )
  end

  def prompt
    return @prompt if defined? @prompt

    txt_search = Books::TextSearchService.new(book_id: @book.id, query: query).call
    @prompt = Query::PromptGenerationService
      .new(context: txt_search, book: @book, query: query)
      .call
  end

  def query
    q = params.require(:query)
    q[-1].present? && q[-1] != '?' ? "#{q}?" : q 
  end
end
