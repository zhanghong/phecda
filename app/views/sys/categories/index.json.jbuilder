json.array!(@sys_categories) do |sys_category|
  json.extract! sys_category, :id, :name, :status, :parent_id
  json.url sys_category_url(sys_category, format: :json)
end
