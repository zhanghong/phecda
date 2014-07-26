class CreateCoreRoles < ActiveRecord::Migration
  def change
    create_table :core_roles do |t|
      t.integer       :account_id
      t.string        :name,          default: "",    limit: 20
      t.integer       :updater_id,      default: 0
      t.integer       :deleter_id,      default: 0
      t.integer       :deleted_at
      t.timestamps
    end
    add_index :core_roles,  [:account_id, :deleter_id],    name: "idx_by_account_id"
  end
end
