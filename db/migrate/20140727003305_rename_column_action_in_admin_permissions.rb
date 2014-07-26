class RenameColumnActionInAdminPermissions < ActiveRecord::Migration
  def change
    rename_column   :admin_permissions,   :action,  :action_name
  end
end
