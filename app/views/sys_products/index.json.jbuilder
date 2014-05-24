json.array!(@sys_product) do |sys_product|
  json.extract! sys_product, :id, :category_id, :title, :num
end
