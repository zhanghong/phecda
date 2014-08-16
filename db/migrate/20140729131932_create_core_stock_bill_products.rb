class CreateCoreStockBillProducts < ActiveRecord::Migration
  def change
    create_table :core_stock_bill_products do |t|
      t.integer       :stock_bill_id,   default: 0
      t.integer       :sys_product_id,  default: 0
      t.integer       :sys_sku_id,      default: 0
      t.integer       :number,          default: 0
      t.integer       :autual_number,   default: 0
      t.decimal       :unit_price,      precision: 8, scale: 2
      t.decimal       :sum_price,       precision: 8, scale: 2     
      t.timestamps
    end

    add_index   :core_stock_bill_products,  [:stock_bill_id],   name: "idx_by_stock_bill_id"
  end
end
