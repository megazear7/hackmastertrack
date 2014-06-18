json.array!(@proficiencies) do |proficiency|
  json.extract! proficiency, :id
  json.url proficiency_url(proficiency, format: :json)
end
