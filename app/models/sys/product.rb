# encoding : utf-8 -*-
# create_table "sys_products", force: true do |t|
#   t.integer "account_id"
#   t.integer "category_id",                default: 0
#   t.string  "title",          limit: 100, default: ""
#   t.integer "num",                        default: 0
#   t.text    "description"
#   t.string  "approve_status", limit: 15,  default: "instock"
#   t.boolean "has_discount",               default: false
#   t.string  "image"
#   t.string  "outer_id"
#   t.string  "product_id",     limit: 30
# end

# add_index "sys_products", ["account_id", "category_id"], name: "idx_by_account_id_and_category_id", using: :btree
class Sys::Product < ActiveRecord::Base
	belongs_to		:account
	belongs_to		:category,		class_name: "Sys::Category"
	has_many			:sku,					class_name: "Sys::Sku"
end
