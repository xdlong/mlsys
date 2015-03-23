class ActRelationship
  include Mongoid::Document
  field :priority_number, :type=> Integer

  belongs_to :source, :class_name=>"Act",:foreign_key=>'source_id',:inverse_of=>:outbounds, autosave: true, index: true
  belongs_to :target, :class_name=>"Act",:foreign_key=>'target_id',:inverse_of=>:inbounds, autosave: true, index: true

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