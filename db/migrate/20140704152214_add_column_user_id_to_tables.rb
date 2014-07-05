class AddColumnUserIdToTables < ActiveRecord::Migration
  def change
    add_column  :products,      :user_id,   :integer,   default: 0
    add_column  :sku_bindings,  :account_id,  :integer, default: 0
    add_column  :sku_bindings,  :user_id,     :integer, default: 0
    add_column  :skus,          :user_id,     :integer, default: 0
    add_column  :sys_categories,  :user_id,   :integer, default: 0
    add_column  :sys_categories_properties, :account_id, :integer, default: 0
    add_column  :sys_categories_properties, :user_id, :integer, default: 0
    add_column  :sys_products,    :user_id,   :integer, default: 0
    add_column  :sys_properties,  :user_id,   :integer, default: 0
    add_column  :sys_property_values, :user_id, :integer, default: 0
    add_column  :sys_sku_property_values, :account_id,  :integer, default: 0
    add_column  :sys_sku_property_values, :user_id,     :integer, default: 0
    add_column  :sys_skus,        :user_id,     :integer, default: 0
  end
end
