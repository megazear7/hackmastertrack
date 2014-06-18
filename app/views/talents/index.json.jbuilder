json.array!(@talents) do |talent|
  json.extract! talent, :id
  json.url talent_url(talent, format: :json)
end
