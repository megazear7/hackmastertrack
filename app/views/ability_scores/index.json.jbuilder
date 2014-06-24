json.array!(@ability_scores) do |ability_score|
  json.extract! ability_score, :id
  json.url ability_score_url(ability_score, format: :json)
end
