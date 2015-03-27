class Participation::Subject < Participation
  belongs_to :manufactured_product, class_name: "Role::ManufacturedProduct", foreign_key: 'role_id', autosave: true, index: true

  def initialize attrs=nil
    super attrs
    self.type_code||='SBJ'
  end
end