class AddColumnIsDeletedToProperties < ActiveRecord::Migration
  def change
    add_column  :sys_properties,          :deleted_at,    :datetime
    add_column  :sys_property_values,     :deleted_at,    :datetime
  end
end
