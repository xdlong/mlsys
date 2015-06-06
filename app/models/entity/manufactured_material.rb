class Entity::ManufacturedMaterial < Entity::Material
  field :lot_number_text, type: String

  def initialize attrs=nil
    super attrs
    self.class_code||='NMAT'
    self.status_code||='N'
  end
end