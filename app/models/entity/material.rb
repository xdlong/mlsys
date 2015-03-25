class Entity::Material < Entity
  field :form_code,       type: Basic::ConceptDescriptor
  field :existence_time,  type: Basic::ContinuousSet

  def initialize attrs=nil
    super attrs
    self.class_code||='MAT'
    self.status_code||='N'
  end
end