class Role::Member < Role
  belongs_to :member_person, class_name: 'Entity::Person', foreign_key: 'player_id', autosave: true

  def initialize attrs = nil
    super attrs
    self.class_code||='MBR'
  end
end