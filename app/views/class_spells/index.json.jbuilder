json.array!(@class_spells) do |class_spell|
  json.extract! class_spell, :id
  json.url class_spell_url(class_spell, format: :json)
end
