class AddColumnDeleterIdToModels < ActiveRecord::Migration
  def change
    add_column  :core_seller_areas,   :deleted_at,    :datetime
    add_column  :core_seller_areas,   :deleter_id,    :integer,   default: 0
    add_column  :core_sellers,        :deleter_id,    :integer,   default: 0
    add_column  :core_stock_products, :deleter_id,    :integer,   default: 0
    add_column  :core_stocks,         :deleter_id,    :integer,   default: 0         
    add_column  :sku_bindings,        :deleted_at,    :datetime
    add_column  :sku_bindings,        :deleter_id,    :integer,   default: 0
    add_column  :skus,                :deleter_id,    :integer,   default: 0
    add_column  :sys_categories,      :deleter_id,    :integer,   default: 0
    add_column  :sys_categories_properties, :deleted_at,    :datetime
    add_column  :sys_categories_properties, :deleter_id,    :integer,   default: 0
    add_column  :sys_products,        :deleter_id,    :integer,   default: 0
    add_column  :sys_properties,      :deleter_id,    :integer,   default: 0
    add_column  :sys_property_values, :deleter_id,    :integer,   default: 0
    add_column  :sys_sku_property_values, :deleted_at,    :datetime
    add_column  :sys_sku_property_values, :deleter_id,    :integer,   default: 0
    add_column  :sys_skus,            :deleter_id,    :integer,   default: 0
  end
end
