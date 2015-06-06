#encoding: utf-8
class Act
  include Mongoid::Document
  field :class_code,  type: String
  field :mood_code,   type: String
  field :ii,          type: Basic::InstanceIdentifier
  field :code,        type: Basic::ConceptDescriptor
  field :title,       type: String
  field :text,        type: String
  field :status_code, type: String
  field :created_at,  type: Time
  field :updated_at,  type: Time

  has_many :participation, class_name: 'Participation', foreign_key: 'act_id', inverse_of: :act, autosave: true
  has_many :outbounds, class_name: 'ActRelationship', foreign_key: 'source_id', inverse_of: :source, autosave: true
  has_many :inbounds, class_name: 'ActRelationship', foreign_key: 'target_id', inverse_of: :target, autosave: true

  def initialize attrs=nil
    case attrs
    when Hash
      attrs.delete(:id)
      owner=fetch_ownner_attribute(attrs)
      super owner
      inverses=attrs.select {|k,v| not owner.include?(k) }
      set_inverse_instance inverses
    else
      super
    end
    self.created_at ||= Time.now()
    self.updated_at = Time.now()
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
    self.updated_at = Time.now()
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
        part_elm=elm.select {|k,v| part.embedded_relations.include?(k.to_s)||(not part.relations.include?(k.to_s.gsub(/\[(\d+)\]/,''))) }
        ele.each do |role_key,role_elm|
          next unless role_elm.is_a?(Hash)
          if meta=part.associations[role_key.to_s.gsub(/\[(\d+)\]/,'')]
            role_elm.deep_symbolize_keys!
            role=role_elm[:id].present? ? eval(meta.class_name).find(role_elm[:id]) : nil
            role||=eval(meta.class_name).where('ii.root' => role_elm[:ii][:root].to_s, 'ii.extension' => role_elm[:ii][:extension].to_s).last if role_elm[:ii]&&role_elm[:ii].is_a?(Hash)&&role_elm[:ii][:root].present?&&role_elm[:ii][:extension].present?
            if role
              role_elm.delete(:id)
              role.update_attributes(role_elm)
              if exist_part = self.participation.map{|v| v if v.role_id == role.id}.compact.last
                part_elm.delete(:id)
                exist_part.update_attributes(part_elm.merge({:type_code=>role_elm[:type_code]}))
              else
                self.participation<<eval(name).new(part_elm.merge({:type_code=>role_elm[:type_code],:role=>role}))
              end
            else
              role=eval(meta.class_name).new role_elm
              self.participation<<eval(name).new(part_elm.merge({:type_code=>role_elm[:type_code],:role=>role}))
            end
          end
        end
      end
    when Hash
      part_elm=element.select {|k,v| part.embedded_relations.include?(k.to_s)||(not part.relations.include?(k.to_s.gsub(/\[(\d+)\]/,''))) }
      element.each do |role_key,role_elm|
        if meta=part.associations[role_key.to_s.gsub(/\[(\d+)\]/,'')]
          case role_elm
          when Hash
            role_elm.deep_symbolize_keys!
            role=role_elm[:id].present? ? eval(meta.class_name).find(role_elm[:id]) : nil
            role||=eval(meta.class_name).where('ii.root' => role_elm[:ii][:root].to_s, 'ii.extension' => role_elm[:ii][:extension].to_s).last if role_elm[:ii]&&role_elm[:ii].is_a?(Hash)&&role_elm[:ii][:root].present?&&role_elm[:ii][:extension].present?
            if role
              role_elm.delete(:id)
              role.update_attributes(role_elm)
              if exist_part = self.participation.map{|v| v if v.role_id == role.id}.compact.last
                part_elm.delete(:id)
                exist_part.update_attributes(part_elm.merge({:type_code=>role_elm[:type_code]}))
              else
                self.participation<<eval(name).new(part_elm.merge({:type_code=>role_elm[:type_code],:role=>role}))
              end
            else
              role=eval(meta.class_name).new role_elm
              self.participation<<eval(name).new(part_elm.merge({:type_code=>role_elm[:type_code],:role=>role}))
            end
          when Array
            role_elm.each do |elm|
              next unless elm.is_a?(Hash)
              elm.deep_symbolize_keys!
              role=elm[:id].present? ? eval(meta.class_name).find(elm[:id]) : nil
              role||=eval(meta.class_name).where('ii.root' => elm[:ii][:root].to_s, 'ii.extension' => elm[:ii][:extension].to_s).last if elm[:ii]&&elm[:ii].is_a?(Hash)&&elm[:ii][:root].present?&&elm[:ii][:extension].present?
              if role
                elm.delete(:id)
                role.update_attributes(elm)
                if exist_part = self.participation.map{|v| v if v.role_id == role.id}.compact.last
                  part_elm.delete(:id)
                  exist_part.update_attributes(part_elm.merge({:type_code=>role_elm[:type_code]}))
                else
                  self.participation<<eval(name).new(part_elm.merge({:type_code=>role_elm[:type_code],:role=>role}))
                end
              else
                role=eval(meta.class_name).new elm
                self.participation<<eval(name).new(part_elm.merge({:type_code=>role_elm[:type_code],:role=>role}))
              end
            end
          end
        end
      end
    end
  end

  def set_act_relationship name,element
    relate=eval(name).new
    case element
    when Array
      element.each do |elm|
        relate_elm=elm.select {|k,v| relate.embedded_relations.include?(k.to_s)||(not relate.relations.include?(k.to_s.gsub(/\[(\d+)\]/,''))) }
        elm.each do |act_key, act_elm|
          next unless act_elm.is_a?(Hash)
          if meta=relate.associations[act_key.to_s.gsub(/\[(\d+)\]/,'')]
            act_name= meta.class_name=='Act::Act' ? 'Act' : meta.class_name
            act_elm.deep_symbolize_keys!
            act=act_elm[:id].present? ? eval(act_name).find(act_elm[:id]) : nil
            act||=eval(act_name).where(mood_code:mood_code, 'ii.root' => act_elm[:ii][:root].to_s, 'ii.extension' => act_elm[:ii][:extension].to_s).last if act_elm[:ii]&&act_elm[:ii].is_a?(Hash)&&act_elm[:ii][:root].present?&&act_elm[:ii][:extension].present?
            if act
              act_elm.delete(:id)
              act.update_attributes(act_elm)
              if meta.inverse_of[/target/]
                if exist_relate = self.outbounds.map{|v| v if v.target_id == act.id}.compact.last
                  relate_elm.delete(:id)
                  exist_relate.update_attributes(relate_elm)
                else
                  self.outbounds<<eval(name).new(relate_elm.merge({:target=>act}))
                end
              elsif meta.inverse_of[/source/]
                if exist_relate = self.inbounds.map{|v| v if v.source_id == act.id}.compact.last
                  relate_elm.delete(:id)
                  exist_relate.update_attributes(relate_elm)
                else
                  self.inbounds<<eval(name).new(relate_elm.merge({:source=>act}))
                end
              end
            else
              act=eval(act_name).new act_elm
              self.outbounds<<eval(name).new(relate_elm.merge({:target=>act})) if meta.inverse_of[/target/]
              self.inbounds<<eval(name).new(relate_elm.merge({:source=>act})) if meta.inverse_of[/source/]
            end
          end
        end
      end
    when Hash
      relate_elm=element.select {|k,v| relate.embedded_relations.include?(k.to_s)||(not relate.relations.include?(k.to_s.gsub(/\[(\d+)\]/,''))) }
      element.each do |act_key, act_elm|
        if meta=relate.associations[act_key.to_s.gsub(/\[(\d+)\]/,'')]
          act_name= meta.class_name=='Act::Act' ? 'Act' : meta.class_name 
          case act_elm
          when Hash
            act_elm.deep_symbolize_keys!
            act=act_elm[:id].present? ? eval(act_name).find(act_elm[:id]) : nil
            act||=eval(act_name).where(mood_code:mood_code, 'ii.root' => act_elm[:ii][:root].to_s, 'ii.extension' => act_elm[:ii][:extension].to_s).last if act_elm[:ii]&&act_elm[:ii].is_a?(Hash)&&act_elm[:ii][:root].present?&&act_elm[:ii][:extension].present?
            if act
              act_elm.delete(:id)
              act.update_attributes(act_elm)
              if meta.inverse_of[/target/]
                if exist_relate = self.outbounds.map{|v| v if v.target_id == act.id}.compact.last
                  relate_elm.delete(:id)
                  exist_relate.update_attributes(relate_elm)
                else
                  self.outbounds<<eval(name).new(relate_elm.merge({:target=>act}))
                end
              elsif meta.inverse_of[/source/]
                if exist_relate = self.inbounds.map{|v| v if v.source_id == act.id}.compact.last
                  relate_elm.delete(:id)
                  exist_relate.update_attributes(relate_elm)
                else
                  self.inbounds<<eval(name).new(relate_elm.merge({:source=>act}))
                end
              end
            else
              act=eval(act_name).new act_elm
              self.outbounds<<eval(name).new(relate_elm.merge({:target=>act})) if meta.inverse_of[/target/]
              self.inbounds<<eval(name).new(relate_elm.merge({:source=>act})) if meta.inverse_of[/source/]
            end
          when Array
            act_elm.each do |elm|
              next unless elm.is_a?(Hash)
              elm.deep_symbolize_keys!
              act=elm[:id].present? ? eval(act_name).find(elm[:id]) : nil
              act||=eval(act_name).where(mood_code:mood_code, 'ii.root' => elm[:ii][:root].to_s, 'ii.extension' => elm[:ii][:extension].to_s).last if elm[:ii]&&elm[:ii].is_a?(Hash)&&elm[:ii][:root].present?&&elm[:ii][:extension].present?
              if act
                elm.delete(:id)
                act.update_attributes(elm)
                if meta.inverse_of[/target/]
                  if exist_relate = self.outbounds.map{|v| v if v.target_id == act.id}.compact.last
                    relate_elm.delete(:id)
                    exist_relate.update_attributes(relate_elm)
                  else
                    self.outbounds<<eval(name).new(relate_elm.merge({:target=>act}))
                  end
                elsif meta.inverse_of[/source/]
                  if exist_relate = self.inbounds.map{|v| v if v.source_id == act.id}.compact.last
                    relate_elm.delete(:id)
                    exist_relate.update_attributes(relate_elm)
                  else
                    self.inbounds<<eval(name).new(relate_elm.merge({:source=>act}))
                  end
                end
              else
                act=eval(act_name).new elm
                self.outbounds<<eval(name).new(relate_elm.merge({:target=>act})) if meta.inverse_of[/target/]
                self.inbounds<<eval(name).new(relate_elm.merge({:source=>act})) if meta.inverse_of[/source/]
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