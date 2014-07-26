json.array!(@core_stock_products) do |core_stock_product|
  json.extract! core_stock_product, :id, :stock_id, :sys_product_id, :sys_sku_id, :activite_num, :actual_num
  json.url core_stock_product_url(core_stock_product, format: :json)
end
