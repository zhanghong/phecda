# encoding : utf-8 -*-
# create_table "tb_trades", force: true do |t|
#   t.integer  "shop_id",                                                   default: 0          #所属shop
#   t.string   "tid",                    limit: 18,                         default: ""         #交易编号 (父订单的交易编号)
#   t.integer  "num",                                                       default: 0          #商品购买数量
#   t.string   "num_iid",                limit: 15,                         default: ""         #商品数字编号
#   t.string   "status",                 limit: 30,                         default: ""         #交易状态
#   t.string   "title",                  limit: 30,                         default: ""         #交易标题
#   t.integer  "point_fee",                                                 default: 0          #买家使用积分,下单时生成，且一直不变

#   t.decimal  "price",                             precision: 8, scale: 2, default: 0.0        #商品价格
#   t.decimal  "discount_fee",                      precision: 8, scale: 2, default: 0.0        #建议使用trade.promotion_details查询系统优惠 系统优惠金额
#   t.decimal  "total_fee",                         precision: 8, scale: 2, default: 0.0        #商品金额
#   t.decimal  "credit_card_fee",                   precision: 8, scale: 2, default: 0.0        #使用信用卡支付金额数
#   t.decimal  "adjust_fee",                        precision: 8, scale: 2, default: 0.0        #卖家手工调整金额
#   t.decimal  "commission_fee",                    precision: 8, scale: 2, default: 0.0        #交易佣金
#   t.decimal  "payment",                           precision: 8, scale: 2, default: 0.0        #实付金额
#   t.decimal  "post_fee",                          precision: 8, scale: 2, default: 0.0        #邮费
#   t.decimal  "received_payment",                  precision: 8, scale: 2, default: 0.0        #卖家实际收到的支付宝打款金额
#   t.decimal  "cod_fee",                           precision: 8, scale: 2, default: 0.0        #货到付款服务费

#   t.string   "cod_status",             limit: 30,                         default: ""         #货到付款物流状态
#   t.string   "trade_from",             limit: 10,                         default: ""         #交易内部来源
#   t.string   "trade_memo",                                                default: ""         #交易备注
#   t.datetime "created"                                                                        #交易创建时间
#   t.datetime "end_time"                                                                       #交易结束时间
#   t.datetime "modified"                                                                       #交易修改时间
#   t.datetime "pay_time"                                                                       #付款时间
#   t.datetime "send_time"                                                                      #订单将在此时间前发出，主要用于预售订单
#   t.datetime "consign_time"                                                                   #卖家发货时间

#   t.string   "shipping_type",          limit: 15,                         default: ""         #创建交易时的物流方式
#   t.string   "alipay_id",              limit: 20,                         default: ""         #买家的支付宝id号
#   t.string   "alipay_no",                                                 default: "30"       #支付宝交易号
#   t.string   "buyer_alipay_no",        limit: 50,                         default: ""         #买家支付宝账号
#   t.string   "buyer_nick",             limit: 50,                         default: ""         #买家昵称
#   t.string   "buyer_area",             limit: 30,                         default: ""         #买家下单的地区
#   t.string   "buyer_email",            limit: 50,                         default: ""         #买家邮件地址
#   t.string   "buyer_message",                                             default: ""         #买家留言
#   t.string   "buyer_memo",                                                default: ""         #买家备注
#   t.string   "seller_nick",            limit: 30,                         default: ""         #卖家昵称
#   t.string   "seller_memo",                                               default: ""         #卖家备注

#   t.string   "receiver_name",          limit: 20,                         default: ""         #收货人的姓名
#   t.string   "receiver_state",         limit: 20,                         default: ""         #收货人的所在省份
#   t.string   "receiver_city",          limit: 20,                         default: ""         #收货人的所在城市
#   t.string   "receiver_district",      limit: 20,                         default: ""         #收货人的所在地区
#   t.string   "receiver_address",       limit: 70,                         default: ""         #收货人的详细地址
#   t.string   "receiver_zip",           limit: 6,                          default: ""         #收货人的邮编
#   t.string   "receiver_mobile",        limit: 11,                         default: ""         #收货人的手机号码
#   t.string   "receiver_phone",         limit: 20,                         default: ""         #收货人的电话号码
#   t.string   "invoice_name",           limit: 50,                         default: ""         #发票抬头
#   t.string   "invoice_type",           limit: 10,                         default: ""         #发票类型

#   t.integer  "buyer_obtain_point_fee",                                    default: 0          #买家获得积分,返点的积分
#   t.integer  "real_point_fee",                                            default: 0          #买家实际使用积分
#   t.boolean  "is_lgtype",                                                 default: false      #是否保障速递
#   t.boolean  "is_brand_sale",                                             default: false      #表示是否是品牌特卖
#   t.boolean  "is_force_wlb",                                              default: false      #订单是否强制使用物流宝发货
#   t.boolean  "is_daixiao",                                                default: false      #表示订单交易是否含有对应的代销采购单
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
class Tb::Trade < Trade
  belongs_to  :shop,    class_name: "Tb::Shop"
  has_many    :orders,  class_name: "Tb::Order", dependent: :destroy
end
