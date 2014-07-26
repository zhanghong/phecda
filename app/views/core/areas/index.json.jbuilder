json.array!(@core_areas) do |core_area|
  json.id   core_area.id
  json.name core_area.name
  json.parent_id  core_area.parent_id
  json.isParent   core_area.is_leaf
  json.checked    !core_area.is_leaf
end
