# encoding : utf-8 -*-
# create_table "tb_sku_properties", force: true do |t|
#   t.integer  "sku_id",            default: 0
#   t.integer  "property_value_id", default: 0
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
# add_index "tb_sku_properties", ["sku_id", "property_value_id"], name: "idx_by_sku_id_and_property_id", using: :btree
class Tb::SkuProperty < ActiveRecord::Base
	belongs_to	:sku,		class_name: "Tb::Sku"
	belongs_to	:property_value,	class_name: "Tb::PropertyValue"
end
