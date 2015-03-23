module Basic
  class InstanceIdentifier
    attr_accessor :root, :extension

    def to_a
      [@root,@extension]
    end

    def to_hash
      {:root=>@root, :extension=>@extension}
    end

    def to_s  attrs=nil,options=nil,&block
      [self.root,self.extension].join(' ')
    end

    def demotion= arg
      set_attributes arg
    end

    def inspect
      "#<#{self.class} _id: #{self.__id__} #{self.to_hash.map{|k,v| "#{k}: #{v.inspect}"}.join(', ')}>"
    end

    def set_attributes attrs, options
      attrs||={}
      case attrs
      when Hash
        qualifier=%w(root extension)
        qualifier.each do |i|
          self.send "#{i}=", attrs[i.to_sym]||attrs[i] if attrs[i.to_sym]||attrs[i]
        end
      when String
        split=attrs.split(' ',2)
        @root=split.first
        @extension=split.last if split.count>1
      else
        @root=attrs.to_s
      end
    end

    def update_attributes attrs=nil ,options=nil
      set_attributes attrs, options
    end

    def initialize attrs=nil ,options=nil
      set_attributes attrs, options
    end

    def mongoize
      to_hash
    end

    class << self
      def demongoize(object)
        InstanceIdentifier.new(object)
      end

      def mongoize(object)
        case object
        when InstanceIdentifier then object.mongoize
        when hash then InstanceIdentifier.new(object).mongoize
        else object
        end
      end

      def evolve(object)
        if object.is_a? Basic::InstanceIdentifier
          object.to_hash
        else
          object
        end
      end
    end
  end

  class ConceptDescriptor
    attr_accessor :code, :display_name, :code_system, :code_system_name

    def to_a
      [code, display_name, code_system, code_system_name]
    end

    def to_hash
      {code:code, display_name:display_name, code_system:code_system, code_system_name:code_system_name}
    end

    def to_s  attrs=nil,options=nil,&block
      display_name ? display_name : code
    end

    def demotion= arg
      set_attributes arg
    end

    def inspect
      "#<#{self.class} _id: #{self.__id__} #{self.to_hash.map{|k,v| "#{k}: #{v.inspect}"}.join(', ')}>"
    end

    def set_attributes attrs=nil, options=nil
      attrs||={}
      case attrs
      when Hash
        qualifier=%w(code display_name code_system code_system_name)
        qualifier.each do |i|
          self.send "#{i}=", attrs[i.to_sym]||attrs[i] if attrs[i.to_sym]||attrs[i]
        end
      when Array
        @code=attrs.first
        @code_system=attrs.last if attrs.count>1
        @display_name=attrs[1] if attrs.count>2
      else
        @code=attrs.to_s
      end
    end

    def update_attributes attrs=nil ,options=nil
      set_attributes attrs, options
    end

    def initialize attrs=nil ,options=nil
      set_attributes attrs, options
    end

    def mongoize
      to_hash
    end

    class << self
      def demongoize(object)
        ConceptDescriptor.new(object)
      end

      def mongoize(object)
        case object
        when ConceptDescriptor then object.mongoize
        when hash then ConceptDescriptor.new(object).mongoize
        else object
        end
      end

      def evolve(object)
        if object.is_a? Basic::ConceptDescriptor
          object.to_hash
        else
          object
        end
      end
    end
  end
end