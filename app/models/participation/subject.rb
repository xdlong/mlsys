class Participation::Subject < Participation
  belongs_to :manufactured_product, :class_name=>"Role::ManufacturedProduct", :foreign_key=>'role_id', :autosave=>true, index: true
end