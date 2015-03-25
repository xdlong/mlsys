class Act::Classification < Act
  has_many :subject, class_name: 'Participation::Subject', foreign_key: 'act_id', autosave: true
  has_many :component, class_name: 'ActRelationship::Component', foreign_key: 'source_id', inverse_of: :source, autosave: true
end