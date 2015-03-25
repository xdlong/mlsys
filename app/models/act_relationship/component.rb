class ActRelationship::Component < ActRelationship
  belongs_to :classification, class_name: "Act::Classification", foreign_key: 'target_id', inverse_of: :inbounds, autosave: true, index: true
end