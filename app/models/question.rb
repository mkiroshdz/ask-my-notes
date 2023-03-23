class Question
  include Mongoid::Document
  
  field :query, type: String
  field :response, type: Array 

  belongs_to :book
end