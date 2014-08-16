class RenameColumnStatusInCoreStockBillLogs < ActiveRecord::Migration
  def change
    rename_column :core_stock_bill_logs,  :status,  :state
  end
end
