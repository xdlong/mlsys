#encoding: utf-8
class RoleLink
  include Mongoid::Document
  field :priority_number, :type => Integer
  
  belongs_to :source, class_name: 'Role', foreign_key: 'source_id', inverse_of: :outbound_links, autosave: true
  belongs_to :target, class_name: 'Role', foreign_key: 'target_id', inverse_of: :inbound_links, autosave: true
  validates_presence_of :source_id
  validates_presence_of :target_id

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
