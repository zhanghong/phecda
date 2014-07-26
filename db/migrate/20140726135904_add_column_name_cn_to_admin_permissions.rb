class AddColumnNameCnToAdminPermissions < ActiveRecord::Migration
  def change
    add_column  :admin_permissions, :tag_name, :string,    limit: 40
  end
end
