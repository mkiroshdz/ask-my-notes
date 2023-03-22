require 'tokenizers'

class Page
  include Mongoid::Document
  
  EMBEDDINGS_MODEL = 'text-search-curie-doc-001'.freeze
  EMBEDDINGS_MODEL_MAX_TOKENS = 2046
  PAGE_FRAGMENT_SIZE = 4000

  field :index, type: Integer
  field :fragment, type: Integer
  field :content, type: String

  validates :index, :fragment, :content, presence: true

  belongs_to :book
  has_one :embedding
end