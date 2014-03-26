# encoding : utf-8 -*-
# create_table "sys_sku_property_values", force: true do |t|
#   t.integer  "sku_id",            default: 0
#   t.integer  "property_value_id", default: 0
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end

# add_index "sys_sku_property_values", ["sku_id", "property_value_id"], name: "idx_by_sku_id_and_property_id", using: :btree
class Sys::SkuPropertyValue < ActiveRecord::Base
	belongs_to	:sku,		class_name: "Sys::Sku"
	belongs_to	:property_value,		class_name: "Sys::PropertyValue"
end
