json.array!(@core_logistics) do |core_logistic|
  json.extract! core_logistic, :id, :name
  json.url core_logistic_url(core_logistic, format: :json)
end
