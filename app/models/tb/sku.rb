# encoding : utf-8 -*-
# create_table "skus", force: true do |t|
#   t.integer  "account_id",            default: 0
#   t.integer  "product_id",            default: 0
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.integer  "quantity",              default: 0
#   t.string   "ts_id",      limit: 30, default: ""
#   t.boolean  "is_hide",               default: false
#   t.string   "type",                  default: "20"
#   t.datetime "deleted_at"
#   t.integer  "user_id",               default: 0
# end
# add_index "skus", ["account_id", "product_id"], name: "idx_by_shop_id_and_product_id", using: :btree
class Tb::Sku < Sku
	has_many		:sku_properties,	class_name: "Tb::SekuProperty", dependent: :destroy
  has_many    :property_values, class_name: "Tb::PropertyValue", through: :sku_properties
  has_many    :sku_bindings
  has_many    :sys_skus,        class_name: "Sys::Sku", through: :sku_bindings

  def self.inner_list_attributes
    %w(ts_id propertites_values quantity sku_bindings)
  end

  def propertites_values
    # propertites_values.join(";")
    ""
  end

  def full_name
    self.product.try(:title)
  end
end
