class AddColumnUserIdToCoreStockProducts < ActiveRecord::Migration
  def change
    add_column  :core_stock_products, :user_id, :integer, default: 0
  end
end
