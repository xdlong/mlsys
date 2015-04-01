#encoding:utf-8
class Act::Registration < Act
  has_many :subject, class_name: 'Participation::Subject', foreign_key: 'act_id', inverse_of: :participation, autosave: true
  has_many :coverage, class_name: 'ActRelationship::Coverage', foreign_key: 'source_id', inverse_of: :source, autosave: true
  def initialize attrs = nil
    super attrs
    self.class_code||='REG'
    self.mood_code||='EVN'
    self.status_code||='N'
  end
end