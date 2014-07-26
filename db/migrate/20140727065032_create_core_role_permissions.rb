class CreateCoreRolePermissions < ActiveRecord::Migration
  def change
    create_table :core_role_permissions do |t|
      t.integer       :account_id,          default: 0
      t.integer       :role_id,             default: 0
      t.integer       :permission_id,       default: 0
      t.integer       :updater_id,          default: 0
      t.integer       :deleter_id,          default: 0
      t.datetime      :deleted_at
      t.timestamps
    end
  end
end
