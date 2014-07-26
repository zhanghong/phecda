class CreateCoreLogisticAreas < ActiveRecord::Migration
  def change
    create_table :core_logistic_areas do |t|
      t.integer       :account_id
      t.integer       :logistic_id
      t.integer       :area_id
      t.integer       :updater_id,      defalut: 0
      t.datetime      :deleted_at
      t.integer       :deleter_id,      defalut: 0
      t.timestamps
    end
    add_index   :core_logistic_areas,   [:account_id, :area_id],    name: "idx_by_account_id_and_area_id"
  end
end
