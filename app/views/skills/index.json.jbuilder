json.array!(@skills) do |skill|
  json.extract! skill, :id
  json.url skill_url(skill, format: :json)
end
