# encoding : utf-8 -*-
# create_table "core_stock_bills", force: true do |t|
#   t.integer  "account_id",               default: 0
#   t.integer  "stock_id",                 default: 0
#   t.integer  "trade_id",                 default: 0
#   t.integer  "logistic_id",              default: 0
#   t.string   "type",          limit: 40, default: ""
#   t.string   "cat_name",      limit: 40, default: ""
#   t.string   "state",         limit: 20, default: "created"
#   t.string   "customer_name",            default: ""
#   t.integer  "area_id",                  default: 0
#   t.string   "address"
#   t.string   "mobile",        limit: 30
#   t.string   "phone",         limit: 30
#   t.text     "remark"
#   t.integer  "updater_id",               default: 0
#   t.integer  "deleter_id",               default: 0
#   t.datetime "deleted_at"
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.string   "identifier",    limit: 30, default: ""
# end
# add_index "core_stock_bills", ["account_id", "stock_id", "status"], name: "idx_by_account_id_and_stock_id_and_status", using: :btree
# add_index "core_stock_bills", ["account_id", "stock_id", "trade_id"], name: "idx_by_account_id_and_stock_id_and_trade_id", using: :btree
class Core::StockInBill < Core::StockBill
  PUBLIC_IN_CATS = [["调拨入库", "IIR"], ["正常入库", "IFG"], ["拆分入库", "ICF"], ["加工入库", "IOT"], ["退货入库", "IRR"], ["特殊入库(免费)", "IMF"], ["成品入库", "ICP"]]
  PRIVATE_IN_CATS   = [["期初入库","IINITIAL"],["调整入库","IVIRTUAL"]]
  STATES = [["待审核", "created"], ["已审核", "audited"], ["已入库", "stocked"], ["已取消", "cancled"]]

  def self.list_shown_attributes
    %w(identifier cat_name_zh state_name updater_name updated_at)
  end

  def self.detail_shown_attributes
    %w(identifier stock_name cat_name_zh state_name customer_name area_id address mobile phone remark updater_name updated_at)
  end

  def self.all_cats
    PUBLIC_IN_CATS + PRIVATE_IN_CATS
  end

  def type_name
    "入库单"
  end

  def cat_name_zh
    item = Core::StockInBill.all_cats.find{|item| item.last == self.cat_name}
    if item.blank?
      self.cat_name
    else
      item.first
    end
  end

  def state_name
    item = Core::StockInBill::STATES.find{|i| i.last == self.state}
    if item.blank?
      self.state
    else
      item.first
    end
  end
end