json.array!(@language_identification_lexicon_characters) do |language_identification_lexicon_character|
  json.extract! language_identification_lexicon_character, :id, :contained
  json.url language_identification_lexicon_character_url(language_identification_lexicon_character, format: :json)
end
