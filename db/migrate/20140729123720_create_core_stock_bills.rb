class CreateCoreStockBills < ActiveRecord::Migration
  def change
    create_table :core_stock_bills do |t|
      t.integer         :account_id,  default: 0
      t.integer         :stock_id,  default: 0
      t.string          :trade_id,  default: 0
      t.integer         :logistic_id, default: 0
      t.string          :type,    default: "",    limit: 40
      t.string          :cat_name,  default: "",  limit: 40
      t.string          :status,    default: "",  limit: 40
      t.string          :customer_name, default: ""
      t.integer         :area_id,   default: 0
      t.string          :address
      t.string          :mobile,    limit: 30
      t.string          :phone,     limit: 30
      t.text            :remark
      t.integer         :updater_id,  default: 0
      t.integer         :deleter_id,  default: 0
      t.datetime        :deleted_at
      t.timestamps
    end

    add_index   :core_stock_bills,  [:account_id, :stock_id, :trade_id],   name: "idx_by_account_id_and_stock_id_and_trade_id"
    add_index   :core_stock_bills,  [:account_id, :stock_id, :status],   name: "idx_by_account_id_and_stock_id_and_status"
  end
end
