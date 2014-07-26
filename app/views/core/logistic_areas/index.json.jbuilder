json.array!(@core_logistic_areas) do |core_logistic_area|
  json.extract! core_logistic_area, :id, :logistic_id, :area_id
  json.url core_logistic_area_url(core_logistic_area, format: :json)
end
