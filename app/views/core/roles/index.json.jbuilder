json.array!(@core_roles) do |core_role|
  json.extract! core_role, :id, :name
  json.url core_role_url(core_role, format: :json)
end
