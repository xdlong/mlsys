class Role::ManufacturedProduct < Role
  belongs_to :product, class_name: "Entity::Product", inverse_of: :playeds, autosave: true
end