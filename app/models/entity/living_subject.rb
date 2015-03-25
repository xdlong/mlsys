class Entity::LivingSubject < Entity
  field :administrative_gender_code, type: Basic::ConceptDescriptor
  field :birth_time,                 type: Time

  def initialize attrs=nil
    super attrs
    self.class_code||='LIV'
  end

  def age
    calc_age(birth_time,Time.now) if birth_time
  end

  def age_at time
    calc_age(birth_time,DateTime.parse(time.to_s)) if birth_time
  end

  def calc_age birth,time,level=0
    sour = AGE_TMP[level][:source]
    if (tmp = eval("time.#{sour} - birth.#{sour}")).abs >= (AGE_TMP[level][:min]||1)
     ret = "#{tmp} #{AGE_TMP[level][:name]}"
    else
      if level+1 < AGE_TMP.size
        ret = (tmp > 0 ? "#{tmp} #{AGE_TMP[level][:name]}" : '')
        case sour
        when 'year','month'
          since = eval("birth.#{sour}s_since(#{tmp})")
        when 'day'
          since = birth + 24*60*60*tmp
        when 'hour'
          since = birth + 60*60*tmp
        end
        ret += calc_age(since,time,level+1)
      else
        ret = "< #{AGE_TMP[level][:min]} #{AGE_TMP[level][:name]}"
      end
    end
    ret
  end

  AGE_TMP =[
    {source:'year',name:I18n.t('unit.age_of_year'),min:1},
    {source:'month',name:I18n.t('datetime.prompts.month'),min:1},
    {source:'day',name:I18n.t('datetime.prompts.day'),min:1},
    {source:'hour',name:I18n.t('datetime.prompts.hour'),min:1},
    {source:'min',name:I18n.t('datetime.prompts.minute'),min:1},
  ]
  
  def administrative_gender
    administrative_gender_code.display_name
  end

  def birth_time
    (ret = super) ? (ret - 8*60*60) : nil
  end
end