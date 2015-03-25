class Role::ManufacturedProduct < Role
  belongs_to :product, class_name: "Entity::Product", inverse_of: :playeds, autosave: true

  def initialize attrs=nil
  	super attrs
  	self.class_code='MANU'
  end
end