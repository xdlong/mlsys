#encoding: utf-8
class Role
  include Mongoid::Document
  field :class_code, type: String
  field :ii,         type: Basic::InstanceIdentifier
  field :code,       type: Basic::ConceptDescriptor
  field :name,       type: String
  field :desc,       type: String
  field :quantity,   type: Basic::PhysicalQuantity
  field :created_at, type: Time
  field :updated_at, type: Time
  
  has_many :outbound_links, class_name: 'RoleLink', foreign_key: 'source_id', inverse_of: :source, autosave: true
  has_many :inbound_links, class_name: 'RoleLink', foreign_key: 'target_id', inverse_of: :target, autosave: true
  has_many :participation, class_name: 'Participation', foreign_key: 'role_id', inverse_of: :role, autosave: true
  belongs_to :player, class_name: 'Entity', inverse_of: :playeds, autosave: true
  belongs_to :scoper, class_name: 'Entity', inverse_of: :scopeds, autosave: true

  def initialize attrs=nil
    attrs||={}
    attrs.delete(:id)
    owner=fetch_ownner_attribute(attrs)
    super owner
    inverses=attrs.select {|k,v| not owner.include?(k) }
    set_inverse_instance inverses
    self.created_at ||= Time.now()
    self.updated_at = Time.now()
  end

  def update_attributes attrs=nil
    attrs||={}
    owner=fetch_ownner_attribute(attrs)
    super owner
    inverses=attrs.select {|k,v| not owner.include?(k) }
    set_inverse_instance inverses
    self.updated_at = Time.now()
  end

  def fetch_ownner_attribute args=nil
    args||={}
    args.select {|k,v| self.embedded_relations.include?(k.to_s)||(not self.relations.include?(k.to_s.gsub(/\[(\d+)\]/,''))) }
  end

  def set_inverse_instance args
    args||={}
    args.each do |inverse_key,inverse_elm|
      next unless inverse_elm.present?
      if meta=self.associations[inverse_key.to_s.gsub(/\[(\d+)\]/,'')] 
        case meta.class_name
        when /^Entity::/
          inverse_elm.deep_symbolize_keys!
          ent=inverse_elm[:id] ? eval(meta.class_name).find(inverse_elm[:id]) : nil
          ent||=eval(meta.class_name).where('ii.extension' => inverse_elm[:ii][:extension].to_s,'ii.root' => inverse_elm[:ii][:root].to_s).last if inverse_elm[:ii]&&inverse_elm[:ii].is_a?(Hash)&&inverse_elm[:ii][:root].present?&&inverse_elm[:ii][:extension].present?
          if ent
            inverse_elm.delete(:id)
            ent.update_attributes(inverse_elm)
            self.player=ent if meta.foreign_key[/player/]
            self.scoper=ent if meta.foreign_key[/scoper/]
          else
            self.player=eval(meta.class_name).new(inverse_elm) if meta.foreign_key[/player/]
            self.scoper=eval(meta.class_name).new(inverse_elm) if meta.foreign_key[/scoper/]
          end
        when /^Participation::/
          set_participation meta.class_name, inverse_elm
        when /^RoleLink::/
          set_role_link meta.class_name, inverse_elm
        end
      end
    end 
  end

  def set_participation name,element
    part=eval(name).new
    case element
    when Hash
      part_elm=element.select {|k,v| part.embedded_relations.include?(k.to_s)||(not part.relations.include?(k.to_s.gsub(/\[(\d+)\]/,''))) }
      element.each do |act_key,act_elm|
        next unless act_elm.present?
        if meta=part.associations[act_key.to_s.gsub(/\[(\d+)\]/,'')]
          case act_elm
          when Hash
            act_elm.deep_symbolize_keys!
            act=act_elm[:id] ? eval(meta.class_name).find(act_elm[:id]) : nil
            act||=eval(meta.class_name).where('ii.extension' => act_elm[:ii][:extension].to_s,'ii.root' => act_elm[:ii][:root].to_s).last if act_elm[:ii]&&act_elm[:ii].is_a?(Hash)&&act_elm[:ii][:root].present?&&act_elm[:ii][:extension].present?
            if act
              act_elm.delete(:id)
              act.update_attributes(act_elm)
              if exist_part = self.participation.map{|v| v if v.act_id == act.id}.compact.last
                part_elm.delete(:id)
                exist_part.update_attributes(part_elm)
              else
                self.participation<<eval(name).new(part_elm.merge({:act=>act}))
              end
            else
              act=eval(meta.class_name).new act_elm
              self.participation<<eval(name).new(part_elm.merge({:act=>act}))
            end
          when Array
            act_elm.each do |elm|
              next unless elm.is_a?(Hash)
              elm.deep_symbolize_keys!
              act=elm[:id] ? eval(meta.class_name).find(elm[:id]) : nil
              act||=eval(meta.class_name).where('ii.extension' => elm[:ii][:extension].to_s,'ii.root' => elm[:ii][:root].to_s).last if elm[:ii]&&elm[:ii].is_a?(Hash)&&elm[:ii][:root].present?&&elm[:ii][:extension].present?
              if act
                elm.delete(:id)
                act.update_attributes(elm)
                if exist_part = self.participation.map{|v| v if v.act_id == act.id}.compact.last
                  part_elm.delete(:id)
                  exist_part.update_attributes(part_elm)
                else
                  self.participation<<eval(name).new(part_elm.merge({:act=>act}))
                end
              else
                act=eval(meta.class_name).new elm
                self.participation<<eval(name).new(part_elm.merge({:act=>act}))
              end
            end
          end
        end 
      end
    when Array
      element.each do |elm|
        part_elm=elm.select {|k,v| part.embedded_relations.include?(k.to_s)||(not part.relations.include?(k.to_s.gsub(/\[(\d+)\]/,''))) }
        elm.each do |act_key,act_elm|
          if meta=part.associations[act_key.to_s.gsub(/\[(\d+)\]/,'')]
            case act_elm
            when Hash
              act_elm.deep_symbolize_keys!
              act=act_elm[:id] ? eval(meta.class_name).find(act_elm[:id]) : nil
              act||=eval(meta.class_name).where('ii.extension' => act_elm[:ii][:extension].to_s,'ii.root' => act_elm[:ii][:root].to_s).last if act_elm[:ii]&&act_elm[:ii].is_a?(Hash)&&act_elm[:ii][:root].present?&&act_elm[:ii][:extension].present?
              if act
                act_elm.delete(:id)
                act.update_attributes(act_elm)
                if exist_part = self.participation.map{|v| v if v.act_id == act.id}.compact.last
                  part_elm.delete(:id)
                  exist_part.update_attributes(part_elm)
                else
                  self.participation<<eval(name).new(part_elm.merge({:act=>act}))
                end
              else
                act=eval(meta.class_name).new act_elm
                self.participation<<eval(name).new(part_elm.merge({:act=>act}))
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

  def set_role_link name, element
    link=eval(name).new
    case element
    when Array
      element.each do |elm|
        link_elm=elm.select {|k,v| link.embedded_relations.include?(k.to_s)||(not link.relations.include?(k.to_s.gsub(/\[(\d+)\]/,''))) }
        elm.each do |role_key, role_elm|
          if meta=link.associations[role_key.to_s.gsub(/\[(\d+)\]/,'')]
            role_elm_ii = (role_elm&&(role_elm[:id]||role_elm[:ii]))
            role_elm_ii = role_elm_ii.symbolize_keys if role_elm_ii
            role=eval(meta.class_name).where('ii.root' => role_elm_ii[:root].to_s, 'ii.extension' => role_elm_ii[:extension].to_s).last  if role_elm_ii&&role_elm_ii.is_a?(Hash)
            if role
              role_elm.delete(:id)
              role.update_attributes(role_elm)
              self.outbound_links<<eval(name).new(link_elm.merge({:target=>role})) unless self.outbound_links.map{|v| v.target_id}.include?(role.id)
            else
              role=eval(meta.class_name).new role_elm
              self.outbound_links<<eval(name).new(link_elm.merge({:target=>role}))
            end
          end
        end
      end
    when Hash
      link_elm=element.select {|k,v| link.embedded_relations.include?(k.to_s)||(not link.relations.include?(k.to_s.gsub(/\[(\d+)\]/,''))) }
      element.each do |role_key, role_elm|
        if meta=link.associations[role_key.to_s.gsub(/\[(\d+)\]/,'')]
          case role_elm
          when Hash
            role_elm_ii = (role_elm&&(role_elm[:ii]||role_elm[:id]))
            role_elm_ii = role_elm_ii.symbolize_keys if role_elm_ii
            role=eval(meta.class_name).where('ii.root' => role_elm_ii[:root].to_s, 'ii.extension' => role_elm_ii[:extension].to_s).last  if role_elm_ii&&role_elm_ii.is_a?(Hash)
            if role
              role_elm.delete(:id)
              role.update_attributes(role_elm)
              self.outbound_links<<eval(name).new(link_elm.merge({:target=>role})) unless self.outbound_links.map{|v| v.target_id}.include?(role.id)
            else
              role=eval(meta.class_name).new role_elm
              self.outbound_links<<eval(name).new(link_elm.merge({:target=>role}))
            end
          end
        end
      end
    end
  end
end