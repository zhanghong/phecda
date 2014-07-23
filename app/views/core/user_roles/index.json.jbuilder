json.array!(@core_user_roles) do |core_user_role|
  json.extract! core_user_role, :id, :user_id, :role_id
  json.url core_user_role_url(core_user_role, format: :json)
end
