class RenameColumnUpdaterIdInTables < ActiveRecord::Migration
  def change
    add_column  :core_areas,    :updater_id,    :integer,   default: 0
    rename_column   :core_seller_areas, :user_id,   :updater_id
    rename_column   :core_sellers,      :user_id,   :updater_id
    rename_column   :core_stock_products, :user_id, :updater_id
    rename_column   :core_stocks,         :user_id, :updater_id
    rename_column   :products,            :user_id, :updater_id
    rename_column   :sku_bindings,        :user_id, :updater_id
    rename_column   :skus,                :user_id, :updater_id
    rename_column   :sys_categories,      :user_id, :updater_id
    rename_column   :sys_categories_properties,   :user_id,   :updater_id
    rename_column   :sys_products,        :user_id, :updater_id
    rename_column   :sys_properties,      :user_id, :updater_id
    rename_column   :sys_property_values, :user_id, :updater_id
    rename_column   :sys_sku_property_values, :user_id, :updater_id
    rename_column   :sys_skus,            :user_id,   :updater_id
    
  end
end
