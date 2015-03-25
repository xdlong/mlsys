class RoleLink::RelatedTo < RoleLink

  def initialize attrs=nil
    super attrs
    self.type_code='REL'
  end
end