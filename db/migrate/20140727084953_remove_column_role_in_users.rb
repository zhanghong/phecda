class RemoveColumnRoleInUsers < ActiveRecord::Migration
  def up
    remove_column   :users,   :role
  end

  def down
    add_column      :users,   :role,    :string,    limit: 10
  end
end
