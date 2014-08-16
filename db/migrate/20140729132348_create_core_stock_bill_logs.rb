class CreateCoreStockBillLogs < ActiveRecord::Migration
  def change
    create_table :core_stock_bill_logs do |t|
      t.integer       :stock_bill_id,     default: 0
      t.string        :status,            default: "",  limit: 40
      t.integer       :updater_id,        default: 0
      t.timestamps
    end
    add_index   :core_stock_bill_logs,  [:stock_bill_id], name: "idx_by_stock_bill_id"
  end
end
