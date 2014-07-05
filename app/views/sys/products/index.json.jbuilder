json.array!(@sys_products) do |sys_product|
  json.extract! sys_product, :id, :title, :num, :description, :approve_status
  json.url sys_product_url(sys_product, format: :json)
end
