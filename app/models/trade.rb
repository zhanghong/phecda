# encoding : utf-8 -*-
# create_table "trades", force: true do |t|
#   t.integer  "shop_id",                                                   default: 0
#   t.string   "tid",                    limit: 18,                         default: ""
#   t.integer  "num",                                                       default: 0
#   t.string   "num_iid",                limit: 15,                         default: ""
#   t.string   "status",                 limit: 30,                         default: ""
#   t.string   "title",                  limit: 30,                         default: ""
#   t.integer  "point_fee",                                                 default: 0
#   t.decimal  "price",                             precision: 8, scale: 2, default: 0.0
#   t.decimal  "discount_fee",                      precision: 8, scale: 2, default: 0.0
#   t.decimal  "total_fee",                         precision: 8, scale: 2, default: 0.0
#   t.decimal  "credit_card_fee",                   precision: 8, scale: 2, default: 0.0
#   t.decimal  "adjust_fee",                        precision: 8, scale: 2, default: 0.0
#   t.decimal  "commission_fee",                    precision: 8, scale: 2, default: 0.0
#   t.decimal  "payment",                           precision: 8, scale: 2, default: 0.0
#   t.decimal  "post_fee",                          precision: 8, scale: 2, default: 0.0
#   t.decimal  "received_payment",                  precision: 8, scale: 2, default: 0.0
#   t.decimal  "cod_fee",                           precision: 8, scale: 2, default: 0.0
#   t.string   "cod_status",             limit: 30,                         default: ""
#   t.string   "trade_from",             limit: 10,                         default: ""
#   t.string   "trade_memo",                                                default: ""
#   t.datetime "created"
#   t.datetime "end_time"
#   t.datetime "modified"
#   t.datetime "pay_time"
#   t.datetime "send_time"
#   t.datetime "consign_time"
#   t.string   "shipping_type",          limit: 15,                         default: ""
#   t.string   "alipay_id",              limit: 20,                         default: ""
#   t.string   "alipay_no",                                                 default: "30"
#   t.string   "buyer_alipay_no",        limit: 50,                         default: ""
#   t.string   "buyer_nick",             limit: 50,                         default: ""
#   t.string   "buyer_area",             limit: 30,                         default: ""
#   t.string   "buyer_email",            limit: 50,                         default: ""
#   t.string   "buyer_message",                                             default: ""
#   t.string   "buyer_memo",                                                default: ""
#   t.string   "seller_nick",            limit: 30,                         default: ""
#   t.string   "seller_memo",                                               default: ""
#   t.string   "receiver_name",          limit: 50,                         default: ""
#   t.string   "receiver_state",         limit: 20,                         default: ""
#   t.string   "receiver_city",          limit: 20,                         default: ""
#   t.string   "receiver_district",      limit: 20,                         default: ""
#   t.string   "receiver_address",       limit: 70,                         default: ""
#   t.string   "receiver_zip",           limit: 10,                         default: ""
#   t.string   "receiver_mobile",        limit: 30,                         default: ""
#   t.string   "receiver_phone",         limit: 30,                         default: ""
#   t.string   "invoice_name",           limit: 50,                         default: ""
#   t.string   "invoice_type",           limit: 10,                         default: ""
#   t.integer  "buyer_obtain_point_fee",                                    default: 0
#   t.integer  "real_point_fee",                                            default: 0
#   t.boolean  "is_lgtype",                                                 default: false
#   t.boolean  "is_brand_sale",                                             default: false
#   t.boolean  "is_force_wlb",                                              default: false
#   t.boolean  "is_daixiao",                                                default: false
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.string   "type",                   limit: 30,                         default: ""
# end
class Trade < ActiveRecord::Base
  
end
