class AddColumnIsSuperAdminToUsers < ActiveRecord::Migration
  def change
    add_column    :users,   :is_superadmin,   :boolean,   default: false
    User.update_all(is_superadmin: false)
  end
end
