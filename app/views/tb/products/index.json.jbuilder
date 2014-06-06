json.array!(@tb_products) do |tb_product|
  json.extract! tb_product, :id, :index, :show, :edit, :update
  json.url tb_product_url(tb_product, format: :json)
end
