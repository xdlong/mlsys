class Role
  include Mongoid::Document
  field :ii, type: Basic::InstanceIdentifier
  field :code, type: Basic::ConceptDescriptor
  field :name, type: String
  field :desc, type: String
  
  has_many :outbound_links, :class_name=>'RoleLink', :foreign_key=>'source_id', :autosave=>true
  has_many :inbound_links,  :class_name=>'RoleLink', :foreign_key=>'target_id', :autosave=>true
  has_many :participation, :class_name=>'Participation', :foreign_key=>'role_id', :autosave=>true
  belongs_to :player, :class_name=>"Entity", :inverse_of=>:playeds, :autosave=>true
  belongs_to :scoper, :class_name=>"Entity", :inverse_of=>:scopeds, :autosave=>true

  def initialize attrs=nil
    attrs||={}
    owner=fetch_ownner_attribute(attrs)
    super owner
    inverses=attrs.select {|k,v| not owner.include?(k) }
    set_inverse_instance inverses
  end

  def update_attributes attrs=nil
    attrs||={}
    owner=fetch_ownner_attribute(attrs)
    super owner
    inverses=attrs.select {|k,v| not owner.include?(k) }
    set_inverse_instance inverses
  end

  def fetch_ownner_attribute args=nil
    args||={}
    args.select {|k,v| self.embedded_relations.include?(k.to_s)||(not self.relations.include?(k.to_s.gsub(/\[(\d+)\]/,''))) } #modified by xiewu 20130824 origin self.fields.include?(k.to_s)||self.embedded_relations.include?(k.to_s)
  end

  def set_inverse_instance args
    args||={}
    args.each do |inverse_key,inverse_elm|
      if meta=self.associations[inverse_key.to_s.gsub(/\[(\d+)\]/,'')] 
        case meta.class_name
        when /^Entity::/
          inverse_elm_ii = (inverse_elm&&(inverse_elm[:id]||inverse_elm[:ii]))
          inverse_elm_ii = inverse_elm_ii.symbolize_keys if inverse_elm_ii
          ent = eval(meta.class_name).where('ii.extension' => inverse_elm_ii[:extension].to_s,'ii.root' => inverse_elm_ii[:root].to_s).last if inverse_elm_ii&&inverse_elm_ii.is_a?(Hash)
          if ent
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
      element.each do |act_key,act_elm|
        if meta=part.associations[act_key.to_s.gsub(/\[(\d+)\]/,'')]
          case act_elm
          when Hash
            act_elm_ii = (act_elm&&(act_elm[:id]||act_elm[:ii]))
            act_elm_ii = act_elm_ii.symbolize_keys if act_elm_ii
            act = eval(meta.class_name).where('ii.extension' => act_elm_ii[:extension].to_s,'ii.root' => act_elm_ii[:root].to_s).last if act_elm_ii&&act_elm_ii.is_a?(Hash)
            if act
              act.update_attributes(act_elm)
              self.participation<<eval(name).new(:act=>act) unless self.participation.map{|v| v.act_id}.include?(act.id)
            else
              act=eval(meta.class_name).new act_elm
              self.participation<<eval(name).new(:act=>act)
            end
          when Array
            act_elm.each do |elm|
              elm_ii = (elm&&(elm[:ii]||elm[:id]))
              elm_ii = elm_ii.symbolize_keys if elm_ii
              act = eval(meta.class_name).where('ii.extension' => elm_ii[:extension].to_s,'ii.root' => elm_ii[:root].to_s).last if elm_ii&&elm_ii.is_a?(Hash)
              if act
                act.update_attributes(elm)
                self.participation<<eval(name).new(:act=>act) unless self.participation.map{|v| v.act_id}.include?(act.id)
              else
                act=eval(meta.class_name).new elm
                self.participation<<eval(name).new(:act=>act)
              end
            end
          end
        end 
      end
    when Array
      element.each do |elm|
        elm.each do |act_key,act_elm|
          if meta=part.associations[act_key.to_s.gsub(/\[(\d+)\]/,'')]
            case act_elm
            when Hash
              act_elm_ii = (act_elm&&(act_elm[:ii]||act_elm[:id]))
              act_elm_ii = act_elm_ii.symbolize_keys if act_elm_ii
              act = eval(meta.class_name).where('ii.extension' => act_elm_ii[:extension].to_s,'ii.root' => act_elm_ii[:root].to_s).last if act_elm_ii&&act_elm_ii.is_a?(Hash)
              if act
                act.update_attributes(act_elm)
                self.participation<<eval(name).new(:act=>act) unless self.participation.map{|v| v.act_id}.include?(act.id)
              else
                act=eval(meta.class_name).new act_elm
                self.participation<<eval(name).new(:act=>act)
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
        elm.each do |role_key, role_elm|
          if meta=link.associations[role_key.to_s.gsub(/\[(\d+)\]/,'')]
            role_elm_ii = (role_elm&&(role_elm[:id]||role_elm[:ii]))
            role_elm_ii = role_elm_ii.symbolize_keys if role_elm_ii
            role=eval(meta.class_name).where('ii.root' => role_elm_ii[:root].to_s, 'ii.extension' => role_elm_ii[:extension].to_s).last  if role_elm_ii&&role_elm_ii.is_a?(Hash)
            if role
              role.update_attributes(role_elm)
              self.outbound_links<<eval(name).new(:target=>role) unless self.outbound_links.map{|v| v.target_id}.include?(role.id)
            else
              role=eval(meta.class_name).new role_elm
              self.outbound_links<<eval(name).new(:target=>role)
            end
          end
        end
      end
    when Hash
      element.each do |role_key, role_elm|
        if meta=link.associations[role_key.to_s.gsub(/\[(\d+)\]/,'')]
          case role_elm
          when Hash
            role_elm_ii = (role_elm&&(role_elm[:ii]||role_elm[:id]))
            role_elm_ii = role_elm_ii.symbolize_keys if role_elm_ii
            role=eval(meta.class_name).where('ii.root' => role_elm_ii[:root].to_s, 'ii.extension' => role_elm_ii[:extension].to_s).last  if role_elm_ii&&role_elm_ii.is_a?(Hash)
            if role
              role.update_attributes(role_elm)
              self.outbound_links<<eval(name).new(:target=>role) unless self.outbound_links.map{|v| v.target_id}.include?(role.id)
            else
              role=eval(meta.class_name).new role_elm
              self.outbound_links<<eval(name).new(:target=>role)
            end
          end
        end
      end
    end
  end
end