class LanguageIdentification::Lexicon
  class << self
    def lead_in file
      ton,i = Time.now,0
      while test = file.gets
        test.gsub(/\uFEFF| *?\n$/,'').split.each{|word| LanguageIdentification::Lexicon::Character.add_word(word);i+=1;}
      end
      [i,i/(Time.now-ton).to_i]
    end
  end
end