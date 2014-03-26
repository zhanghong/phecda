class RenameColumnIncrementInTbProducts < ActiveRecord::Migration
  def change
    rename_column :tb_products, :increment, :price_increment
    rename_column :tb_products, :order_id, :outer_id
  end
end
