class AddColumnFullNameToAdminPermissions < ActiveRecord::Migration
  def change
    add_column  :admin_permissions,   :full_name,   :string,    default: "",  limit: 30
  end
end
