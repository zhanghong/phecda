# encoding : utf-8 -*-
# create_table "sys_property_values", force: true do |t|
#   t.integer  "account_id",             default: 0
#   t.integer  "property_id",            default: 0
#   t.string   "name",        limit: 20, default: ""
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end

# add_index "sys_property_values", ["account_id", "property_id"], name: "idx_by_account_id_and_property_id", using: :btree
class Sys::PropertyValue < ActiveRecord::Base
	belongs_to	:account
	belongs_to	:propery,		class_name: "Sys::Property"
end
