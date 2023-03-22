class Embedding
  include Mongoid::Document

  field :page_id, type: Integer
  field :book_id, type: Integer
  field :vector, type: Array
  field :magnitude, type: Float

  validates :page, :book, :vector, :magnitude, presence: true

  belongs_to :book
  belongs_to :page
end