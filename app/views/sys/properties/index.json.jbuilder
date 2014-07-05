json.array!(@sys_properties) do |sys_property|
  json.extract! sys_property, :id, :name, :status, :values
  json.url sys_property_url(sys_property, format: :json)
end
