# encoding : utf-8 -*-
# create_table "tb_skus", force: true do |t|
#   t.integer  "shop_id",               default: 0
#   t.string   "product_id", limit: 30
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.integer  "quantity",              default: 0
#   t.string   "ts_id",      limit: 30, default: ""
# end
# add_index "tb_skus", ["shop_id", "product_id"], name: "idx_by_shop_id_and_product_id", using: :btree
class Tb::Sku < ActiveRecord::Base
	belongs_to	:shop,	class_name: "Tb::Shop"
	belongs_to	:product,	class_name: "Tb::Product"
	has_many		:sku_properties,	class_name: "Tb::SkuProperty", dependent: :destroy
  has_many    :property_values, class_name: "Tb::PropertyValue", through: :sku_properties
end
