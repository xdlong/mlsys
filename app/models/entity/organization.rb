#encoding:utf-8 
class Entity::Organization < Entity
  has_many :member, class_name: 'Role::Member', inverse_of: 'scopeds', foreign_key: 'scoper_id', autosave: true
  has_many :employee, class_name: 'Role::Employee', inverse_of: 'scopeds', foreign_key: 'scoper_id', autosave: true
  has_many :managed_entity, class_name: 'Role::ManagedEntity', inverse_of: 'scopeds', foreign_key: 'scoper_id', autosave: true

  def initialize attrs=nil
  	super attrs
  	self.class_code||='ORG'
  	self.determiner||='INSTANCE'
    self.status_code||='N'
  end
end