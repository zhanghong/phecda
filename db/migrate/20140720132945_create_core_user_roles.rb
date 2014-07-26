class CreateCoreUserRoles < ActiveRecord::Migration
  def change
    create_table :core_user_roles do |t|
      t.integer         :account_id,    default: 0
      t.integer         :user_id,       default: 0
      t.integer         :role_id,       default: 0
      t.integer         :updater_id,    deafult: 0
      t.integer         :deleter_id,    default: 0
      t.datetime        :delete_time
      t.timestamps
    end
    add_index   :core_user_roles,   [:account_id, :deleter_id, :user_id],  name: "idx_by_account_and_deleter_and_user_id" 
  end
end
