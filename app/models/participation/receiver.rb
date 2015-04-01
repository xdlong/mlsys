class Participation::Receiver < Participation
  belongs_to :classification, class_name: 'Act::Classification', foreign_key: 'act_id', inverse_of: :participation, autosave: true

  def initialize attrs = nil
    super attrs
    self.type_code||='RCV'
  end
end