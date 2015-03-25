class Role::Employee < Role
  field :job_code,       type: Basic::ConceptDescriptor
  field :job_title_name, type: String

  belongs_to :person, class_name: 'Entity::Person', foreign_key: :player_id, autosave: true

  def initialize attrs=nil
    super attrs
    self.class_code||='EMP'
  end
end