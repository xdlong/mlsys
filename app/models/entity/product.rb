class Entity::Product < Entity::ManufacturedMaterial
  has_many :as_manufactured_product, class_name: 'Role::ManagedEntity', inverse_of: 'playeds', foreign_key: 'player_id', autosave: true

  def initialize attrs=nil
    super attrs
    self.class_code||='MMAT'
    self.determiner||='KIND'
  end
end
