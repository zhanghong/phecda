# encoding : utf-8 -*-
# create_table "tb_products", force: true do |t|
#   t.integer  "shop_id"
#   t.integer  "category_id",                                                  default: 0
#   t.string   "detail_url",                                                   default: ""
#   t.string   "num_iid",                  limit: 20,                          default: ""
#   t.string   "title",                    limit: 100,                         default: ""
#   t.string   "sale_type",                limit: 20,                          default: "fixed"
#   t.text     "desc"
#   t.string   "props_name"
#   t.datetime "tb_created_at"
#   t.boolean  "is_lightning_consignment"
#   t.integer  "is_fenxiao"
#   t.integer  "auction_point",                                                default: 0
#   t.string   "property_alias",                                               default: ""
#   t.string   "template_id",              limit: 20,                          default: ""
#   t.string   "features",                                                     default: ""
#   t.integer  "valid_thru",                                                   default: 7
#   t.string   "outer_id",                 limit: 20,                          default: ""
#   t.string   "auto_fill",                limit: 20,                          default: ""
#   t.string   "cid",                      limit: 20,                          default: ""
#   t.string   "seller_cids",                                                  default: ""
#   t.string   "props",                                                        default: ""
#   t.string   "input_pids",                                                   default: ""
#   t.string   "input_str",                                                    default: ""
#   t.string   "pic_url",                                                      default: ""
#   t.integer  "num",                                                          default: 0
#   t.datetime "list_at"
#   t.datetime "delist_at"
#   t.string   "stuff_status",                                                 default: ""
#   t.decimal  "price",                                precision: 8, scale: 2
#   t.decimal  "post_fee",                             precision: 8, scale: 2
#   t.decimal  "express_fee",                          precision: 8, scale: 2
#   t.decimal  "ems_fee",                              precision: 8, scale: 2
#   t.boolean  "has_discount",                                                 default: false
#   t.string   "freight_payer",            limit: 20,                          default: ""
#   t.boolean  "has_invoice"
#   t.boolean  "has_warranty"
#   t.boolean  "has_showcase"
#   t.datetime "tb_modified_at"
#   t.string   "price_increment",                                              default: ""
#   t.string   "approve_status",           limit: 15,                          default: "instock"
#   t.string   "postage_id",               limit: 20,                          default: ""
#   t.string   "product_id",               limit: 20,                          default: ""
#   t.boolean  "is_virtual"
#   t.boolean  "is_taobao"
#   t.boolean  "is_ex"
#   t.boolean  "is_timing"
#   t.boolean  "one_station"
#   t.string   "second_kill",              limit: 20,                          default: ""
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
# add_index "tb_products", ["shop_id", "category_id"], name: "idx_by_shop_id_and_category_id", using: :btree
# add_index "tb_products", ["shop_id", "title"], name: "idx_by_shop_id_and_title", using: :btree
class Tb::Product < ActiveRecord::Base
	belongs_to	:shop,	class_name: "Tb::Shop"
	belongs_to	:category,	class_name: "Tb::Category"
	has_many		:skus,			class_name: "Tb::Sku", dependent: :destroy

  def sync_taobao_skus(item_skus)
    current_sku_ids = []
    if item_skus && item_skus["sku"]
      item_skus["sku"].each do |sku_pro|
        sku = Tb::Sku.find_or_initialize_by(shop_id: shop.id, product_id: self.id, ts_id: sku_pro["sku_id"])
        sku.update(quantity: sku_pro["quantity"])
        sku_pro["properties_name"].to_s.split(";").each do |pro_str|
          pid, nid, name, value = pro_str.split(":")
          property = Tb::Property.find_or_create_by(shop_id: shop.id, name: name)
          value =  Tb::PropertyValue.find_or_create_by(shop_id: shop.id, property_id: property.id, name: value)
          Tb::SkuProperty.find_or_create_by(sku_id: sku.id, property_value_id: value.id)
        end
        current_sku_ids << sku.id
      end
      self.skus.where(["id NOT IN (?)", current_sku_ids]).destroy_all
    else
      self.skus.where(is_hide: false).destroy_all
      create_hide_sku
    end
  end

private
  def create_hide_sku
    if self.skus.blank?
      self.skus.create(shop_id: self.shop_id, ts_id: num_iid, is_hide: true)
    end
  end
end