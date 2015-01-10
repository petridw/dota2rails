class Hero
  include Mongoid::Document
  field :name, type: String
  field :id, type: Integer
end
