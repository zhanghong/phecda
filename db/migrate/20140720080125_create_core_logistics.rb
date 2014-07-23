class CreateCoreLogistics < ActiveRecord::Migration
  def change
    create_table :core_logistics do |t|
      t.integer       :account_id
      t.string        :name,          limit: 15
      t.integer       :updater_id,      defalut: 0
      t.datetime      :deleted_at
      t.integer       :deleter_id,      defalut: 0
      t.timestamps
    end
    add_index   :core_logistics,    [:account_id],    name: "idx_by_account_id"
  end
end
