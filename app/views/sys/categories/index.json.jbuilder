json.array!(@sys_categories) do |sys_category|
  json.extract! sys_category, :name, :account_id, :status, :parent_id, :lft, :rgt, :depth, :use_days
  json.url sys_category_url(sys_category, format: :json)
end
