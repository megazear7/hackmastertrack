json.array!(@item_instances) do |item_instance|
  json.extract! item_instance, :id
  json.url item_instance_url(item_instance, format: :json)
end
