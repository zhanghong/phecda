class AddColumnLevelToAdminPermissions < ActiveRecord::Migration
  def change
    add_column  :admin_permissions, :level, :string,  default: "", limit: 20
  end
end
