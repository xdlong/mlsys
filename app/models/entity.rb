class Entity
  include Mongoid::Document
  field :class_code,  type: String
  field :determiner,  type: String
  field :ii,          type: Basic::InstanceIdentifier
  field :code,        type: Basic::ConceptDescriptor
  field :name,        type: String
  field :desc,        type: String
  field :status_code, type: String
  field :quantity,    type: Basic::PhysicalQuantity
  field :created_at,  type: Time
  field :updated_at,  type: Time

  has_many :playeds, class_name: 'Role', foreign_key: 'player_id', autosave: true
  has_many :scopeds, class_name: 'Role', foreign_key: 'scoper_id', autosave: true

  def initialize attrs=nil
    attrs||={}
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
  end

  def fetch_ownner_attribute args
    args||={}
    result=args.select {|k,v| self.embedded_relations.include?(k.to_s)||(not(self.relations.include?(k.to_s.gsub(/\[(\d+)\]/,''))||self.relations.include?('as_'+k.to_s.gsub(/\[(\d+)\]/,'')))) }
  end

  def set_inverse_instance args
    args||={}
    args.each do |inverse_key,inverse_elm|
      next unless inverse_elm.is_a?(Hash)
      if meta=self.associations[inverse_key.to_s.gsub(/\[(\d+)\]/,'')] || self.associations['as_' + inverse_key.to_s.gsub(/\[(\d+)\]/,'')]
        inverse_elm.deep_symbolize_keys!
        case meta.class_name
        when /^Role::/
          role=inverse_elm[:id].present? ? eval(meta.class_name).find(inverse_elm[:id]) : nil
          role||=eval(meta.class_name).where('ii.root' => inverse_elm[:ii][:root].to_s, 'ii.extension' => inverse_elm[:ii][:extension].to_s).last if inverse_elm[:ii]&&inverse_elm[:ii].is_a?(Hash)
          if role
            role.update_attributes(inverse_elm)
            self.playeds<<role if meta.foreign_key[/player/]&&(not self.playeds.map{|v| v.id}.include?(role.id))
            self.scopeds<<role if meta.foreign_key[/scoper/]&&(not self.scopeds.map{|v| v.id}.include?(role.id))
          else
            self.playeds<<eval(meta.class_name).new(inverse_elm) if meta.foreign_key[/player/]
            self.scopeds<<eval(meta.class_name).new(inverse_elm) if meta.foreign_key[/scoper/]
          end
        when 'User'
          user=inverse_elm[:id].present? ? User.find(inverse_elm[:email]) : nil
          user||=User.where(email: inverse_elm[:email].to_s).last if inverse_elm[:email].present?
          if user
            self.user<<user unless self.user.map{|v| v.id}.include?(user.id)
          end
        end
      end
    end
  end

  def status= args
    case args
    when Hash
      status_code=args[:status].to_s
    else
      status_code=args.to_s
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
