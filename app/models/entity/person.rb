class Entity::Person < Entity::LivingSubject
  field :marital_status_code, type: Basic::ConceptDescriptor

  def initialize attrs=nil
    super attrs
    self.class_code||='PSN'
    self.determiner||='INSTANCE'
    self.status_code||='N'
  end
end