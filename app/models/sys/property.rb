# encoding : utf-8 -*-
# create_table "sys_properties", force: true do |t|
#   t.integer  "account_id",            default: 0
#   t.string   "name",       limit: 30, default: ""
#   t.string   "status",     limit: 20, default: ""
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end

# add_index "sys_properties", ["account_id", "name"], name: "idx_by_account_id_and_name", using: :btree
# add_index "sys_properties", ["account_id", "status"], name: "idx_by_account_id_and_status", using: :btree
class Sys::Property < ActiveRecord::Base
	belongs_to		:account
end
