#encoding:utf-8
class LanguageIdentification::Lexicon::Character
  include Mongoid::Document
  # 自身 基本参数
  field :contained, type: String # 字面量
  # 字词组合 参数
  field :seat_num, type: Integer # 该字在词中的位置序号，0表示词的首字
  field :end_ind, type: Boolean # 该字在词中可否作为尾字
  has_many :next_character, :class_name=>'LanguageIdentification::Lexicon::Character', :inverse_of=> :prec_character, autosave: true
  belongs_to :prec_character, :class_name=>'LanguageIdentification::Lexicon::Character', :inverse_of=> :next_character, autosave: true
  def add_next_character str
    if str.present?
      LanguageIdentification::Lexicon::Character.create(contained:str[0],seat_num:0,end_ind:true) if (str =~ /^[\u4e00-\u9fa5]/) && LanguageIdentification::Lexicon::Character.where(seat_num:0,contained:str[0]).empty?
      character = next_character.where(contained:str[0]).first
      character ||= next_character.create(contained:str[0],seat_num:seat_num+1)
      character.update_attributes(end_ind:(str[1..-1].empty?||character.end_ind)||false)
      character.add_next_character(str[1..-1])
    else
      %{Finished!}
    end
  end
  def words
    ret = []
    next_character.each do |char|
      ret << contained + char.contained if char.end_ind
      ret += char.next_chars.map{|next_char| contained + next_char}
    end
    ret
  end
  define_method(:next_chars){words}
  class << self
    def add_word str
      # str.encode!(Encoding.find("UTF-8"),Encoding.find("GBK"))
      if str.present?
        character = where(seat_num:0,contained:str[0]).first
        character ||= create(contained:str[0],seat_num:0,end_ind:true)
        character.add_next_character(str[1..-1])
      end
    end
    def all_character
      where(seat_num:0).order(contained:1)
    end
  end
end