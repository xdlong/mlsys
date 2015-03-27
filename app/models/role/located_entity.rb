class Role::LocatedEntity  < Role
  has_many :receiver, class_name: 'Participation::Receiver', foreign_key: 'role_id', inverse_of: 'role', autosave:true
  def initialize attrs = nil
    super attrs
    self.class_code||='LOCE'
  end
end