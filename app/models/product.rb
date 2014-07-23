# encoding : utf-8 -*-
# create_table "products", force: true do |t|
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
#   t.string   "type",                     limit: 30
#   t.boolean  "is_sync",                                                      default: false
#   t.datetime "synced_at"
#   t.integer  "account_id",                                                   default: 0
#   t.integer  "user_id",                                                      default: 0
# end

# add_index "products", ["shop_id", "category_id"], name: "idx_by_shop_id_and_category_id", using: :btree
# add_index "products", ["shop_id", "title"], name: "idx_by_shop_id_and_title", using: :btree
class Product < ActiveRecord::Base
  scope :account_scope, -> {where(account_id: Account.current.id)}
  belongs_to  :updater

  def self.find_mine(params)
    conditions = [[]]

    conditions[0] = conditions[0].join(" AND ")
    where(conditions).order(id: :desc)
  end

  def updater_name
    updater.name
  end
end
