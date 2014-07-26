json.array!(@admin_account_permissions) do |admin_account_permission|
  json.extract! admin_account_permission, :id, :account_id
  json.url admin_account_permission_url(admin_account_permission, format: :json)
end
