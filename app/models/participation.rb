#encoding: utf-8
class Participation
  include Mongoid::Document
  field :type_code,       type: String
  field :priority_number, type: Integer

  belongs_to :act, class_name: 'Act', foreign_key: 'act_id', inverse_of: :participation, autosave: true
  belongs_to :role, class_name: 'Role', foreign_key: 'role_id', inverse_of: :participation, autosave: true

  def to_hash
    ret={}
    self.attribute_names.each{|att| ret.merge!(att.to_sym=>self.send(att.to_sym))}
    ret
  end

  def to_hash_no_nil
    ret={}
    self.attributes.each{|key,val| ret.merge!(key.to_sym=>val) if val}
    ret
  end
end