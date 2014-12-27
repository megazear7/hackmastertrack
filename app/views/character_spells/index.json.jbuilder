json.array!(@character_spells) do |character_spell|
  json.extract! character_spell, :id
  json.url character_spell_url(character_spell, format: :json)
end
