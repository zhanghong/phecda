class CreateTableProducts < ActiveRecord::Migration
  def change
    rename_table  :tb_products,   :products
    add_column    :products,   :type,      :string,    limit: 30
    add_column    :products,   :is_sync,       :boolean,   default: false
    add_column    :products,   :synced_at,     :datetime
    Product.update_all(type: "Tb::Product")
  end
end
