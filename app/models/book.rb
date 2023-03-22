class Book
  include Mongoid::Document

  field :title, type: String
  field :author, type: String
  field :url, type: String
  field :cover, type: String
  field :slug, type: String
  field :prompt_headers, type: Array
  field :prompt_hints, type: Array
  
  has_many :pages
  has_many :embeddings

  validates :slug, uniqueness: true
  validates :slug, :title, presence: true

  index({ slug: 1 }, { unique: true, name: 'unique_slug_idx' })
end