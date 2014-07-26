json.array!(@admin_permissions) do |admin_permission|
  json.extract! admin_permission, :id, :module_name, :group_name, :name, :subject_class, :action, :ability_method, :sort_num
  json.url admin_permission_url(admin_permission, format: :json)
end
