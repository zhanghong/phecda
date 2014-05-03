# encoding : utf-8 -*-
# create_table "tb_orders", force: true do |t|
#   t.integer  "trade_id",                                               default: 0       #关联订单
#   t.integer  "num",                                                    default: 0       #购买数量
#   t.string   "oid",                 limit: 18,                         default: ""      #子订单编号
#   t.string   "status",              limit: 30,                         default: ""      #订单状态
#   t.string   "title",               limit: 70,                         default: ""      #商品标题
#   t.string   "num_iid",             limit: 15,                         default: ""      #商品数字ID
#   t.string   "item_meal_id",        limit: 15,                         default: ""      #套餐ID
#   t.string   "sku_id",              limit: 15,                         default: ""      #商品的最小库存单位Sku的id
#   t.string   "outer_sku_id",        limit: 15,                         default: ""      #外部网店自己定义的Sku编号
#   t.string   "order_from",          limit: 10,                         default: ""      #子订单来源
#   t.decimal  "price",                          precision: 8, scale: 2, default: 0.0     #商品价格
#   t.decimal  "total_fee",                      precision: 8, scale: 2, default: 0.0     #应付金额
#   t.decimal  "payment",                        precision: 8, scale: 2, default: 0.0     #子订单实付金额
#   t.decimal  "discount_fee",                   precision: 8, scale: 2, default: 0.0     #子订单级订单优惠金额
#   t.decimal  "adjust_fee",                     precision: 8, scale: 2, default: 0.0     #手工调整金额
#   t.decimal  "divide_order_fee",               precision: 8, scale: 2, default: 0.0     #分摊之后的实付金额
#   t.decimal  "part_mjz_discount",              precision: 8, scale: 2, default: 0.0     #优惠分摊
#   t.datetime "modified"                                                                 #订单修改时间
#   t.datetime "end_time"                                                                 #子订单的交易结束时间
#   t.datetime "consign_time"                                                             #子订单发货时间
#   t.string   "sku_properties_name", limit: 50,                         default: ""      #SKU的值
#   t.string   "refund_id",           limit: 15,                         default: ""      #最近退款ID
#   t.string   "shipping_type",       limit: 15,                         default: ""      #子订单的运送方式
#   t.string   "logistics_company",   limit: 10,                         default: ""      #子订单发货的快递公司名称
#   t.string   "invoice_no",          limit: 15,                         default: ""      #子订单所在包裹的运单号
#   t.string   "store_code",          limit: 20,                         default: ""      #发货的仓库编码
#   t.string   "item_meal_name",      limit: 20,                         default: ""      #套餐的值
#   t.string   "refund_status",       limit: 30,                         default: ""      #退款状态
#   t.string   "outer_iid",           limit: 20,                         default: ""      #商家外部编码
#   t.string   "seller_type",         limit: 1,                          default: ""      #卖家类型
#   t.string   "cid",                 limit: 20,                         default: ""      #交易商品对应的类目ID
#   t.boolean  "is_oversold",                                            default: false   #是否超卖
#   t.boolean  "is_daixiao",                                             default: false   #表示订单交易是否含有对应的代销采购单
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
# add_index "tb_orders", ["trade_id"], name: "idx_by_trade_id", using: :btree
class Tb::Order < ActiveRecord::Base
  belongs_to  :trade,   class_name: "Tb::Trade"
end
