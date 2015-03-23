class Act
  include Mongoid::Document
  field :ii, type: Basic::InstanceIdentifier
  field :code, type: Basic::ConceptDescriptor
  field :title, type: String
  field :text, type: String
  field :status_code, type: String

  has_many :participation, :class_name=>'Participation', :foreign_key=>'act_id', autosave: true
  has_many :outbounds, :class_name=>'ActRelationship', :foreign_key=>'source_id', :inverse_of=> :source, autosave: true
  has_many :inbounds,  :class_name=>'ActRelationship', :foreign_key=>'target_id', :inverse_of=> :target, autosave: true

  def initialize attrs=nil
    case attrs
    when Hash
      owner=fetch_ownner_attribute(attrs)
      super owner
      inverses=attrs.select {|k,v| not owner.include?(k) }
      set_inverse_instance inverses
    else
      super
    end
  end

  def update_attributes attrs=nil
    case attrs
    when Hash
      owner=fetch_ownner_attribute(attrs)
      super owner
      inverses=attrs.select {|k,v| not owner.include?(k) }
      set_inverse_instance attrs
    else
      raise "Error in Act.update_attributes\n params type must be Hash"
    end
  end

  def fetch_ownner_attribute args
    args||={}
    args.select {|k,v| self.embedded_relations.include?(k.to_s)||(not self.relations.include?(k.to_s.gsub(/\[(\d+)\]/,''))) }
  end

  def set_inverse_instance args
    args||={}
    args.each do |inverse_key,inverse_elm|
      if meta=self.associations[inverse_key.to_s.gsub(/\[(\d+)\]/,'')]
        case meta.class_name
        when /^Participation::/
          set_participation meta.class_name, inverse_elm
        when /^ActRelationship::/
          set_act_relationship meta.class_name, inverse_elm
        end
      end
    end 
  end

  def set_participation name,element
    part=eval(name).new
    case element
    when Array
      element.each do |ele|
        ele.each do |role_key,role_elm|
          if meta=part.associations[role_key.to_s.gsub(/\[(\d+)\]/,'')]
            role_elm_ii = role_elm[:id]||role_elm[:ii]
            role=eval(meta.class_name).where('ii.root' => role_elm_ii[:root].to_s, 'ii.extension' => role_elm_ii[:extension].to_s).last if role_elm_ii&&role_elm_ii.is_a?(Hash)
            if role
              role.update_attributes(role_elm)
              self.participation<<eval(name).new(:type_code=>role_elm[:type_code],:role=>role) unless self.participation.map{|v| v.role_id}.include?(role.id)
            else
              role=eval(meta.class_name).new role_elm
              self.participation<<eval(name).new(:type_code=>role_elm[:type_code],:role=>role)
            end
          end
        end
      end
    when Hash
      element.each do |role_key,role_elm|
        if meta=part.associations[role_key.to_s.gsub(/\[(\d+)\]/,'')]
          case role_elm
          when Hash
            role_elm_ii = role_elm[:id]||role_elm[:ii]
            role=eval(meta.class_name).where('ii.root' => role_elm_ii[:root].to_s, 'ii.extension' => role_elm_ii[:extension].to_s).last if role_elm_ii&&role_elm_ii.is_a?(Hash)
            if role
              role.update_attributes(role_elm)
              self.participation<<eval(name).new(:type_code=>role_elm[:type_code],:role=>role) unless self.participation.map{|v| v.role_id}.include?(role.id)
            else
              role=eval(meta.class_name).new role_elm
              self.participation<<eval(name).new(:type_code=>role_elm[:type_code],:role=>role)
            end
          when Array
            role_elm.each do |elm|
              elm_ii = elm&&(elm[:id]||elm[:ii])
              role=eval(meta.class_name).where('ii.root' => elm_ii[:root].to_s, 'ii.extension' => elm_ii[:extension].to_s).last if elm_ii&&elm_ii.is_a?(Hash)
              if role
                role.update_attributes(elm)
                self.participation<<eval(name).new(:type_code=>role_elm[:type_code],:role=>role) unless self.participation.map{|v| v.role_id}.include?(role.id)
              else
                role=eval(meta.class_name).new elm
                self.participation<<eval(name).new(:type_code=>role_elm[:type_code],:role=>role)
              end
            end
          end
        end
      end
    end
  end

  def set_act_relationship name, element
    relate=eval(name).new
    case element
    when Array
      element.each do |elm|
        relate_elm=elm.select {|k,v| relate.embedded_relations.include?(k.to_s)||(not relate.relations.include?(k.to_s.gsub(/\[(\d+)\]/,''))) }
        elm.each do |act_key, act_elm|
          if meta=relate.associations[act_key.to_s.gsub(/\[(\d+)\]/,'')]
            act_name= meta.class_name=='Act::Act' ? 'Act' : meta.class_name
            act_elm_ii = act_elm&&(act_elm[:id]||act_elm[:ii])
            act=eval(act_name).where(mood_code:mood_code, 'ii.root' => act_elm_ii[:root].to_s, 'ii.extension' => act_elm_ii[:extension].to_s).last if act_elm_ii&&act_elm_ii.is_a?(Hash)
            if act
              act.update_attributes(act_elm)
              self.outbounds<<eval(name).new(:target=>act) if meta.inverse_of[/target/]&&(not self.outbounds.map{|v| v.target_id}.include?(act.id))
              self.inbounds<<eval(name).new(:source=>act) if meta.inverse_of[/source/]&&(not self.inbounds.map{|v| v.source_id}.include?(act.id))
            else
              act=eval(act_name).new act_elm
              self.outbounds<<eval(name).new(:target=>act) if meta.inverse_of[/target/]
              self.inbounds<<eval(name).new(:source=>act) if meta.inverse_of[/source/]              
            end            
          end
        end
      end
    when Hash
      element.each do |act_key, act_elm|
        if meta=relate.associations[act_key.to_s.gsub(/\[(\d+)\]/,'')]
          act_name= meta.class_name=='Act::Act' ? 'Act' : meta.class_name 
          case act_elm
          when Hash
              logger.info("act_elm#{act_elm}")
              act_elm_ii = act_elm&&(act_elm[:id]||act_elm[:ii])
              act=eval(act_name).where(mood_code:mood_code, 'ii.root' => act_elm_ii[:root].to_s, 'ii.extension' => act_elm_ii[:extension].to_s).last if act_elm_ii&&act_elm_ii.is_a?(Hash)
              if act
                act.update_attributes(act_elm)
                self.outbounds<<eval(name).new(:target=>act) if meta.inverse_of[/target/]&&(not self.outbounds.map{|v| v.target_id}.include?(act.id))
                self.inbounds<<eval(name).new(:source=>act) if meta.inverse_of[/source/]&&(not self.inbounds.map{|v| v.source_id}.include?(act.id))
              else
                act=eval(act_name).new act_elm
                self.outbounds<<eval(name).new(:target=>act) if meta.inverse_of[/target/]
                self.inbounds<<eval(name).new(:source=>act) if meta.inverse_of[/source/]              
              end    
          when Array
            act_elm.each do |elm|
              elm_ii = elm&&(elm[:id]||elm[:ii])
              act=eval(act_name).where(mood_code:mood_code, 'ii.root' => elm_ii[:root].to_s, 'ii.extension' => elm_ii[:extension].to_s).last if elm_ii&&elm_ii.is_a?(Hash)
              if act
                act.update_attributes(elm)
                self.outbounds<<eval(name).new(:target=>act) if meta.inverse_of[/target/]&&(not self.outbounds.map{|v| v.target_id}.include?(act.id))
                self.inbounds<<eval(name).new(:source=>act) if meta.inverse_of[/source/]&&(not self.inbounds.map{|v| v.source_id}.include?(act.id))
              else
                act=eval(act_name).new elm
                self.outbounds<<eval(name).new(:target=>act) if meta.inverse_of[/target/]
                self.inbounds<<eval(name).new(:source=>act) if meta.inverse_of[/source/]              
              end
            end
          end
        end
      end
    end
  end

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