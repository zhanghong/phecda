# encoding : utf-8 -*-
# create_table "sys_skus", force: true do |t|
#   t.integer  "account_id",            default: 0
#   t.string   "product_id", limit: 30
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end

# add_index "sys_skus", ["account_id", "product_id"], name: "idx_by_account_id_and_product_id", using: :btree
class Sys::Sku < ActiveRecord::Base
	belongs_to		:account
	belongs_to		:product,		class_name: "Sys::Product"
	has_many			:sku_property_value,	class_name: "Sys::SkuPropertyValue"
end
