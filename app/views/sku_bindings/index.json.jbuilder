json.array!(@sku_bindings) do |sku_binding|
  json.extract! sku_binding, :id, :tb_id, :sys_id, :number
  json.url sku_binding_url(sku_binding, format: :json)
end
