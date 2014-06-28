class CreateSkuBindings < ActiveRecord::Migration
  def change
    create_table :sku_bindings do |t|
      t.integer :sku_id
      t.integer :sys_sku_id
      t.integer :sys_sku_number
      t.timestamps
    end
  end
end
