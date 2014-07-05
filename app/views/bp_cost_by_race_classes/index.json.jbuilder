json.array!(@bp_cost_by_race_classes) do |bp_cost_by_race_class|
  json.extract! bp_cost_by_race_class, :id
  json.url bp_cost_by_race_class_url(bp_cost_by_race_class, format: :json)
end
