json.array!(@core_permissions) do |core_permission|
  json.extract! core_permission, :id, :module_name, :group_name, :name, :subject_class, :action, :ability_mothod, :sort_num
  json.url core_permission_url(core_permission, format: :json)
end
