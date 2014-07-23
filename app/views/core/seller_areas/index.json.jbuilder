json.array!(@core_seller_areas) do |core_seller_area|
  json.extract! core_seller_area, :id, :seller_id, :area_id
  json.url core_seller_area_url(core_seller_area, format: :json)
end
