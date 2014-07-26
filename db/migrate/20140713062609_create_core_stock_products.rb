class CreateCoreStockProducts < ActiveRecord::Migration
  def change
    create_table :core_stock_products do |t|
      t.integer       :account_id,    default: 0
      t.integer       :stock_id,      default: 0
      t.integer       :sys_product_id,    default: 0
      t.integer       :sys_sku_id,        default: 0
      t.integer       :activite_num,  default: 0
      t.integer       :actual_num,    default: 0
      t.datetime      :deleted_at
      t.timestamps
    end
  end
end
