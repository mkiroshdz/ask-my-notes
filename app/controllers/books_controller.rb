require 'openai'

class BooksController < ApplicationController
  PROMP_CONTEXT_LENGTH = 500

  def show
    @book = Book.find_by!(slug: params[:id])
  end
end
