class RenameColumnStatusInCoreStockBills < ActiveRecord::Migration
  def change
    rename_column :core_stock_bills,  :status,  :state
    change_column :core_stock_bills,  :state,   :string,    limit: "20",  default: "created"
  end
end
