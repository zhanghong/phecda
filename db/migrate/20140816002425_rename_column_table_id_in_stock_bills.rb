class RenameColumnTableIdInStockBills < ActiveRecord::Migration
  def change
    change_column   :core_stock_bills,   :trade_id,  :integer,   default: 0
    add_column      :core_stock_bills,   :identifier,  :string,  default: "",  limit: 30
  end
end
