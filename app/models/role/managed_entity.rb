class Role::ManagedEntity < Role
  belongs_to :player_person, class_name: 'Entity::Person', foreign_key: 'player_id', inverse_of: :playeds, autosave: true

  def initialize attrs=nil
    super attrs
    self.class_code||='MDE'
  end
end