json.array!(@product) do |product|
  json.extract! product, :id, :category_id, :title, :num
end
