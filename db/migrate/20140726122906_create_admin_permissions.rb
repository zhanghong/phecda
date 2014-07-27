class CreateAdminPermissions < ActiveRecord::Migration
  def change
    rename_table  :core_permissions,   :admin_permissions
  end
end
