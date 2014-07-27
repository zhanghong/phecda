class AddColumnAsNameToAdminAccountPermissions < ActiveRecord::Migration
  def change
    add_column  :admin_account_permissions,   :name,    :string,    limit: 15
  end
end
