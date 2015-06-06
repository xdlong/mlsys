class Entity::Person < Entity::LivingSubject
  field :marital_status_code, type: Basic::ConceptDescriptor

  has_many :user, class_name: 'User', foreign_key: 'person_id', autosave: true

  def initialize attrs=nil
    super attrs
    self.class_code||='PSN'
    self.determiner||='INSTANCE'
    self.status_code||='N'
  end
end