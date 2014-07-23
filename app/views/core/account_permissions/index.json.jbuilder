json.array!(@core_account_permissions) do |core_account_permission|
  json.extract! core_account_permission, :id, :account_id, :permission_id
  json.url core_account_permission_url(core_account_permission, format: :json)
end
