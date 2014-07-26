class CreateCoreAccountPermissions < ActiveRecord::Migration
  def change
    create_table :core_account_permissions do |t|
      t.integer       :account_id,      default: 0
      t.integer       :permission_id,   default: 0
      t.integer       :updater_id,      default: 0
      t.integer       :deleter_id,      default: 0
      t.datetime      :deleted_at
      t.timestamps
    end
    add_index :core_account_permissions,  [:account_id, :deleter_id],  name: "idx_by_account_id_and_deleter_id"
  end
end
