json.array!(@sys_skus) do |sys_sku|
  json.extract! sys_sku, :id, :name, :property_values_name
  json.url sys_sku_url(sys_sku, format: :json)
end
