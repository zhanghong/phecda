json.array!(@tb_skus) do |tb_sku|
  json.extract! tb_sku, :id, :ts_id, :product_id, :quantity
  json.url tb_sku_url(tb_sku, format: :json)
end
