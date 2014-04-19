# encoding : utf-8 -*-
# create_table "tb_properties", force: true do |t|
#   t.integer  "shop_id",               default: 0
#   t.string   "name",       limit: 30, default: ""
#   t.string   "status",     limit: 20, default: ""
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end

# add_index "tb_properties", ["shop_id", "name"], name: "idx_by_shop_id_and_name", using: :btree
# add_index "tb_properties", ["shop_id", "status"], name: "idx_by_shop_id_and_status", using: :btree
class Tb::Property < ActiveRecord::Base
	belongs_to	:shop,	class_name: "Tb::Shop"
	has_many		:values,	class_name: "Tb::PropertyValue", dependent: :destroy
end
