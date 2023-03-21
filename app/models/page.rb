require 'tokenizers'

class Page
  include Mongoid::Document
  
  EMBEDDINGS_MODEL = 'text-search-curie-doc-001'.freeze
  EMBEDDINGS_MODEL_MAX_TOKENS = 2046
  PAGE_FRAGMENT_SIZE = 6000

  field :number, type: Integer
  field :fragment, type: Integer
  field :content, type: String

  validates :number, :fragment, :content, presence: true

  belongs_to :book

  index({ book_id: 1, number: 1, fragment: 1 })
end