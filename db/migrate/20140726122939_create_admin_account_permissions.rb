class CreateAdminAccountPermissions < ActiveRecord::Migration
  def change
    rename_table  :core_account_permissions,    :admin_account_permissions
  end
end
