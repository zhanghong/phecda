class CreateCoreBillProducts < ActiveRecord::Migration
  def change
    create_table :core_bill_products do |t|
      t.integer       :account_id,      default: 0
      t.integer       :stock_bill_id,   default: 0
      t.integer       :sys_product_id,  default: 0
      t.integer       :sys_sku_id,      default: 0
      t.string        :sku_name,        default: "",  limit: 50
      t.integer       :number,          default: 0
      t.decimal       :unit_price,      precision: 8, scale: 2
      t.decimal       :sum_price,       precision: 8, scale: 2
      t.integer       :cal_number,      default: 0
      t.decimal       :cal_unit_price,  precision: 8, scale: 2
      t.decimal       :cal_sum_price,   precision: 8, scale: 2
      t.integer       :updater_id,      default: 0
      t.integer       :deleter_id,      default: 0
      t.datetime      :deleted_at
      t.timestamps
    end

    add_index   :core_bill_products,    [:stock_bill_id],   name: "idx_by_stock_bill_id"
    add_index   :core_bill_products,    [:sys_sku_id],      name: "idx_by_sys_sku_id"
  end
end
