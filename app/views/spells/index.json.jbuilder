json.array!(@spells) do |spell|
  json.extract! spell, :id
  json.url spell_url(spell, format: :json)
end
