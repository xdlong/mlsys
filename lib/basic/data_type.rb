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

  class PhysicalQuantity

    attr_accessor :value,:unit

    def initialize attrs = nil, options =nil
      set_attributes attrs, options
    end

    def update_attributes attrs = nil, options = nil
      set_attributes attrs, options
    end

    def set_attributes attrs = nil, options = nil      
      case attrs
      when ::Array
        @value= attrs.first
        @unit = attrs.last.to_s
      when ::Hash
        @value=(attrs['value']||attrs[:value])
        @unit=(attrs['unit']||attrs[:unit]).to_s
      else 
        pq=/^\s*(\d+\.?\d*)\s*(\w*)/.match attrs.to_s
        if pq
          @value=pq[1]
          @unit=pq[2]
        else
          @value=nil
          @unit=nil
        end 
      end
    end

    def inspect
      "#<#{self.class} _id: #{self.__id__} #{self.to_hash.map{|k,v| "#{k}: #{v.inspect}"}.join(', ')}>"
    end

    def mongoize
      [@value,@unit] 
    end

    def to_a
      [@value,@unit]
    end

    def + arg
      @value=@value+arg
      self
    end

    def canonical 
      "#{value} #{unit}"
    end
    
    def to_s attrs=nil,options=nil,&block
      canonical
    end

    def to_hash
      {:value=>@value,:unit=>@unit}
    end
    
    def canonical= arg
      set arg
    end
    
    private

    def set arg
      case arg
      when String
        pq=/^\s*(\d+\.?\d*)\s*(\w*)/.match arg.to_s
        if pq 
          self.value=pq[1]
          self.unit=pq[2].to_s
        end
      when Array
        self.value=arg.first
        self.unit=arg.last.to_s
      when Hash
        self.value=arg[:value]
        self.unit=arg[:unit].to_s
      end
    end

    class << self
      def demongoize(object)
        PhysicalQuantity.new(object)
      end

      def mongoize(object)
        case object
        when Basic::PhysicalQuantity then object.mongoize
        when hash then PhysicalQuantity.new(object).mongoize
        else object
        end
      end

      def evolve(object)
        if object.is_a? Basic::PhysicalQuantity
          {:value =>object.value, :unit => object.unit}
        else
          object
        end
      end
    end
  end

  class ContinuousSet

    attr_accessor :original_text, :hull

    def initialize attrs = nil, options =nil
      set_attributes attrs, options
    end

    def update_attributes attrs = nil, options = nil
      set_attributes attrs, options
    end
    def set_attributes attrs = nil, options = nil
      case attrs
      when Hash
        @original_text=attrs[:original_text] || attrs['original_text'] || attrs.to_s
        @hull= Interval.new attrs[:hull] || attrs['hull'] || attrs
      else
        @original_text=attrs.to_s
      end
      @original_text||=attrs.to_s
    end

    def interval_at attrs=nil,options=nil

    end
    def interval_at_or_after attrs=nil,options=nil

    end
    def interval_after attrs=nil,options=nil

    end
    def interleaves attrs=nil,options=nil

    end
    def high
      self.hull.high
    end
    def low
      @hull.low
    end
    def width
      @hull.high-@hull.low
    end
    def periodic_hull attrs=nil,options=nil

    end
    def to_a
      [@original_text, @hull.to_a]
    end
    def to_hash
      {:original_text => @original_text, :hull => @hull}
    end
    def inspect
      "#<#{self.class.to_s} _id: #{self.__id__} #{self.to_hash}>"
    end

    def to_s  attrs=nil,options=nil,&block
      original_text.to_s
    end

    def mongoize
      to_hash
    end
    class << self
      def demongoize(object)
        ContinuousSet.new(object)
      end

      def mongoize(object)
        case object
        when ContinuousSet then object.mongoize
          # when Hash then object[:_id]||object
        else
          Basic::ContinuousSet.new(object).mongoize
        end
      end

      def evolve(object)
        if object.is_a? ContinuousSet
          {:original_text => object.original_text, :hull => object.hull}
        else
          object
        end
      end
    end
  end

  # 参数：class：区间数据类型，取 IntegerNumber RealNumber Ratio PhysicalQuantity MonetaryAmount PointInTime中的一个
  #       low，low_closed, high, high_closed, value: class类型的数据值
  #       low不指定时取0，high不指定时为infinity；low_closed与high_closed不指定时为false；value不指定时为空。
  # 返回值： Interval的一个实例对象
  # 示例：
  # @pq={:class =>'PhysicalQuantity',
  #   :low =>{:value => "10", :unit => "cm"}, :low_closed => true,
  #   :high =>{:value => "100", :unit => "cm"}, :high_closed =>true,
  #   :value=>{:value => "60", :unit => "cm"}
  #   }
  # @pqnc={
  #   :low =>{:value => "10", :unit => "cm"}, :low_closed => true,
  #   :high =>{:value => "100", :unit => "cm"}, :high_closed =>false,
  #   :value=>{:value => "60", :unit => "cm"}
  #   }
  # @ipq = Basic::Interval.new @pq
  # @ipq.low.to_s.gsub(' ','').downcase == '10cm'
  # @ipq.value.to_s.gsub(' ','').downcase == '60cm'
  # @ipq.high.to_s.gsub(' ','').downcase == '100cm'
  # @ipq.low_closed == true
  # @ipq.high_closed == true
  # @ipq.to_s.gsub(' ','').downcase == "[10cm..100cm]"
  # @ipq.literal({:delimiter =>'~'},{}).gsub(' ','').downcase == "[10cm~100cm]"

  # @ipqnc = Basic::Interval.new @pqnc
  # @ipqnc.low.to_s.gsub(' ','').downcase== '10cm'
  # @ipqnc.value.to_s.gsub(' ','').downcase== '60cm'
  # @ipqnc.high.to_s.gsub(' ','').downcase== '100cm'
  # @ipqnc.low_closed== true
  # @ipqnc.high_closed== false
  # @ipqnc.to_s.gsub(' ','').downcase== "[10cm..100cm)"
  # @ipqnc.literal({:delimiter =>'~'},{}).gsub(' ','').downcase== "[10cm~100cm)"

  # @ipq = Basic::Interval.new @pq.to_s

  # @ipqnc = Basic::Interval.new @pqnc.to_s

  # t={}
  # @pqnc.each{|k,v| t.merge!({k.to_s => v})}
  # @ipqnc = Basic::Interval.new t

  # @ipqnc = Basic::Interval.new "[10cm..100cm)"

  # @ipqnc = Basic::Interval.new "low:10cm, high:100cm"

  class Interval
    TEMPLATE_VALUE=%w(low low_closed high high_closed center width value)
    TEMPLATE_VALUE.each do |v|
      if (v.to_s !~ /ed\z/)
        self.class_eval("def #{v};@#{v};end")
        self.class_eval("def #{v}=obj;@#{v}=obj;end")
      else
        self.class_eval("def #{v};@#{v}||false;end")
        self.class_eval("def #{v}=obj;@#{v}=obj||false;end")
      end
    end
    CLASS=%w(IntegerNumber RealNumber Ratio PhysicalQuantity MonetaryAmount PointInTime)

    def initialize attrs = nil, options =nil
      set_attributes attrs, options
    end
    def update_attributes attrs = nil, options = nil
      set_attributes attrs, options
    end
    def set_attributes attrs = nil, options = nil
      case attrs
      when String
        case the_str_is_a?(attrs)
        when Hash
          hash=str_to_hash(attrs)
          set_attributes(hash,options)
        when Interval
          interval = str_to_interval(attrs)
          set_attributes(interval,options)
        when Array
          array=str_split(attrs)
          Interval.new(array)
        end
      when Hash
        has_class=nil
        attrs.each do |k,v|
          has_class=true if k&&k.to_s.downcase == 'class'
        end
        attrs[:class] = find_class(attrs) unless has_class
        attrs.each do |k,v|
          attrs[k]=str_to_hash(v) if v&&v.is_a?(String)&&(v.strip =~ /^([\'\"])?(\{)(.*)?(\})([\'\"])?\z/)
        end
        if CLASS.include?(attrs[:class]||attrs['class'])
          @class_name = eval("#{attrs[:class]||attrs['class']}")
          add_incremental_method_to_a_class(@class_name) if !@class_name.method_defined?(:increment)
          add_try_method_to_a_class(@class_name)  if !@class_name.method_defined?(:try)
          add_literal_method_to_a_class(@class_name)  if !@class_name.method_defined?(:literal)
          # add_missing_method_to_a_class(@class_name)  if !@class_name.method_defined?(:method_missing)

          TEMPLATE_VALUE.each do |v|
            if attrs[v.to_sym]||attrs[v]
              if (v.to_s !~ /ed\z/)
                eval("@#{v} = #{attrs[:class]||attrs['class']}.new(attrs[v.to_sym]||attrs[v])")
              else
                closed=attrs[v.to_sym]||attrs[v]||false
                if closed.is_a?(String)
                  if closed.downcase =~ /t/
                    closed=true
                  else
                    closed=false
                  end
                end
                eval("@#{v} = #{closed}")
              end
            end
          end
        else
          @value = attrs
        end
      when Array
        attrs.each{|interal| Basic::Interval.new(interal)}
      end
    end

    def find_class attrs
      ret=nil
      case attrs
      when Hash
        test_value = attrs[:low]||attrs[:high]||attrs['low']||attrs['high']||attrs
        # p "test_value is #{test_value}"
        case test_value
        when Integer
          ret ||= 'IntegerNumber'
        when Float
          ret ||= 'RealNumber'
        when Hash
          # p "test_value is a Hash"
          ret = 'MonetaryAmount' if (test_value.has_key?(:value)||test_value.has_key?('value'))&&(test_value.has_key?(:currency)||test_value.has_key?('currency'))
          ret ='PhysicalQuantity' if (test_value.has_key?(:value)||test_value.has_key?('value'))&&(test_value.has_key?(:unit)||test_value.has_key?('unit'))
          ret = 'Ratio' if (test_value.has_key?(:numerator)||test_value.has_key?('numerator'))&&(test_value.has_key?(:denominator)||test_value.has_key?('denominator'))
        when String
          if the_str_is_date_time(test_value)
            ret = 'PointInTime'
          elsif test_value =~ /(?<currency>[a-zA-Z0-9]+)(\s+)(?<y>[a-fA-F0-9]+)/
            ret ||='MonetaryAmount'
          elsif the_str_is_a?(test_value)==Hash
            ret ||= find_class(str_to_hash(test_value))
          elsif test_value.gsub(' ','') =~ /(?<y>[a-fA-F0-9]+)?(\.)(?<y>[a-fA-F0-9]+)?/
            ret ||='RealNumber'
          else
            ret ||='IntegerNumber'
          end
        else
          ret ||='RealNumber'
        end
        return ret if ret
      when String
        ret ||='RealNumber' if test_value.gsub(' ','') =~ /(?<y>[a-fA-F0-9]+)?(\.)(?<y>[a-fA-F0-9]+)?/
        ret ||=find_class(str_to_hash(test_value))
        ret ||='IntegerNumber'
      end
      return ret if ret
    end

    def the_str_is_date_time str
      /(?<y>[0-9]+)?(?<del>[\s\-_,;.:]+)?(?<m>[0-9]+)?(?<del>[\s\-_,;.:]+)?(?<d>[0-9]+)?(?<del>[\s\-_,;.:]+)?(?<h>[0-9]+)?(?<del>[\s\-_,;.:]+)?(?<min>[0-9]+)?(?<del>[\s\-_,;.:]+)?(?<sec>[0-9]+)?(?<zone_s>[\s\+\-a-zA-Z]+)?(?<zone>[0-9]+)?/ =~ str
      if y&&(y.size==4||y.size==2)&&m&&(m.size==2||m.size==1)&&d&&(d.size==2||d.size==1)
        {:year=>(y.size ==4)? y : ('19'+y), :month =>m, :day=>d,:hour=>h,:minute=>min,:second=>sec,:zone=>zone}
      elsif y&&(y.size==8)&&del
        {:year=>y[0..3], :month =>y[4..5], :day=>y[6..7],:hour=>h,:minute=>min,:second=>sec,:zone=>zone}
      else
        nil
      end
    end

    def the_str_is_a? str
      if hash?(str)
        Hash
      elsif interval?(str)
        Interval
      elsif array?(str)
        Array
      else
        'Unknown'
      end
    end

    def array? str
      !(str.gsub(' ','') =~ /^\[\{([\s:\'\"]+?)?(\w+)([\s\'\"=>:,]+)(\w+)(.*?)\}\]\z/).nil?
    end

    def interval? str
      !(str.gsub(' ','') =~ /^[\[|\(](\w+)(\.\.+)(\w+)(.*?)[\)|\]]\z/).nil?
    end

    def hash? str
      /^([\s|\:|\'|\"]+)?(?<low>[low|high]+)(.*?)?(?<high>[high|low]+)(.*?)?/ =~ str.gsub(' ','').downcase
      !(str.gsub(' ','') =~ /^\{([\s:\'\"]+?)?(\w+)([\s\'\"=>:]+)(\w+)?(.*?)?\}\z/).nil?||!(low.nil?||high.nil?)
    end

    def str_to_interval str
      low = ''
      high =''
      ss = str.gsub(' ','')
      low_closed = (ss[0]=='[') ? true : false
      high_closed = (ss[ss.length-1]==']') ? true : false
      if (ss[0] =~ /\[|\(/) && (ss[ss.length-1] =~ /\)|\]/)
        ss[0]=''
        ss[ss.length-1]=''
      else
        raise 'Interval pramas Not Accessable'
      end
      pos = (ss=~/\.\./)
      low = ss[0...pos]
      high=ss[pos+2...ss.length]
      if high[0] == '.'
        high[0]=''
        high_closed = false
      end
      {:low => low, :high => high, :low_closed => low_closed, :high_closed => high_closed}
    end

    def str_to_hash str
      t={}
      ss=str.gsub(' ','')
      arr=str_split(ss)||[]
      arr.each do |s|
        while s&&(not s.empty?)&&s[0] =~ /[\'\"\.,\s]/
          s[0]=''
        end
        /^(?<del>[\{|\s|:|\'|\"]+)?(?<symbol>[a-zA-Z0-9_]+)(?<del>[\s|\'|\"|=>|:]+)(?<value>.*)?([,|\'|\"|;|:]\z)?/ =~ s
        value[-1] = ''if value&&value[-1] =~/[\'\",;:\.]/
        t.merge!(symbol.to_sym => value)
      end
      t
    end

    def str_split str
      arr=[]
      ss=str.gsub(' ','')

      ss[0]='' if (ss[0]=='['||ss[0]=='{')
      ss[ss.length-1]='' if (ss[ss.length-1]==']'||ss[ss.length-1]=='}')
      lf,rf,as=0,0,0
      level=0
      low,high,preview='','',''
      size=ss.split(/[\{\}\[\]]/).size
      ss.each_char do |c|
        if (c=='{')||(c=='[')
          lf +=1
          level +=1
        elsif (c== '}')||(c==']')
          rf +=1
          level -=1
        elsif (c==',')&&((preview == '}'||preview == ']'||size==1)||(lf == rf))
          as +=1
        end
        if arr[as].nil?
          arr[as]=c
        else
          arr[as] += c
        end
        preview = c
      end
      arr
    end

    def add_missing_method_to_a_class class_name
      # class_name.class_eval("def method_missing name,*args;")
    end

    def add_incremental_method_to_a_class class_name
      add_method_to_other_class(class_name){|block|
        block='def incremental;@incremental||self.try(:one) || self.try(:zero) || 0;end'
      }
    end

    def add_try_method_to_a_class class_name
      class_name.class_eval(
      "def try name,*args
        begin
          self.send(name.to_sym,args[0]) unless self == nilClass || self.class == nilClass
        rescue
          nil
        end
      end")
    end

    def add_literal_method_to_a_class class_name
      class_name.class_eval('alias_method :literal, :to_s')
    end

    def add_method_to_other_class class_name,&block
      class_name.class_eval(yield) if block
    end

    def inspect attrs=nil,options=nil
      "#<#{self.class} id:#{self.__id__} #{self.to_hash}>"
    end

    def to_s  attrs=nil,options=nil,&block
      literal
    end

    def to_hash attrs=nil,options=nil,&block
      t={}
      TEMPLATE_VALUE.each{|k| t.merge!({k.to_sym => eval("@#{k}")}) if eval("@#{k}")}
      t
    end

    def literal attrs=nil,options=nil,&block
      case attrs
      when nil
        interal
      when Hash
        if attrs[:delimiter]||attrs['delimiter']
          options.is_a?(Hash) ? options.merge!(:delimiter => attrs[:delimiter]||attrs['delimiter']) : nil
          astr=attrs[:start]||attrs['start']
          bstr=attrs[:end]||attrs['end']
        end
        interal("[(#{astr})~(#{bstr})]",options,&block)
      when String
        interal(attrs,options,block)
      end
    end

    def interal  attrs=nil,options=nil,&block
      # p '11111111111111111111111111',attrs,options,'7777777777777777777777777'
      # inc = (@low&&@low.incremental)||(@high&&@high.incremental)||(@value&&@value.incremental) || 0
      # p "------------------#{inc}------------------"
      attrs_params=attrs.split('~') if attrs.is_a?(String)
      # p "------------------#{attrs_params}------------------"
      if attrs_params&&attrs_params.size == 2
        attrs_params[0]=attrs_params[0].split(/[\[|\(|\)|\)|\]]/)
        attrs_params[1]=attrs_params[1].split(/[\[|\(|\)|\)|\]]/)
      else
        attrs_params = [nil,nil]
      end
      # p "------------------#{attrs_params}------------------"
      delimiter = options[:delimiter]||options['delimiter'] if options.is_a? Hash
      ret=(@low_closed ? '[' : '(') +
      (@low&&@low.literal(attrs_params[0]) || '0')+
      (delimiter||'..')+
      (@high&&@high.literal(attrs_params[1])||'infinity') +
      (@high_closed ? ']' : ')')
      # (@low.try(:plus,inc).try(:to_s).try(:empty?) ? nil : (','+@low.try(:plus,inc).try(:to_s)))+
    end

    def to_a attrs=nil,options=nil,&block
      []
    end

    def method_missing name,*attrs
      super name,attrs
    end

    def get_class_of_interval
      @class_name
    end

    def mongoize
      to_hash
    end

    class << self

      # Get the object as it was stored in the database, and instantiate
      # this custom class from it.
      def demongoize(object)
        Interval.new(object)
      end

      # Takes any possible object and converts it to how it would be
      # stored in the database.
      def mongoize(object)
        case object
        when Interval then object.mongoize
        when Hash then Interval.new(object).mongoize
        else object
        end
      end
      # Converts the object that was supplied to a criteria and converts it
      # into a database friendly form.
      def evolve(object)
        case object
        when Interval then object.mongoize
        else object
        end
      end
    end
  end
end