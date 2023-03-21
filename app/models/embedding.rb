class Embedding
  include Mongoid::Document

  field :number, type: Integer
  field :fragment, type: Integer
  field :content, type: Array

  validates :number, :fragment, :content, presence: true

  belongs_to :book

  index({ book_id: 1, number: 1, fragment: 1 })
end