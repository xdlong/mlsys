class Entity::Product < Entity::ManufacturedMaterial

  def initialize attrs=nil
    super attrs
    self.class_code||='MMAT'
    self.determiner||='KIND'
  end
end
