class RanameColumnDeleteTimeInUserRoles < ActiveRecord::Migration
  def change
    rename_column   :core_user_roles,   :delete_time, :deleted_at
  end
end
