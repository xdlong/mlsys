class Ms::Drug
  include Mongoid::Document
  field :name, type: String
  field :type, type: String
  field :unit, type: String
  field :unit_price, type: Integer
  field :inventory, type: Integer
  field :byname, type: Array
  field :resume, type: String
  field :notice, type: String
end
