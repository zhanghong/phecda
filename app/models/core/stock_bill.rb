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
class Core::StockBill < ActiveRecord::Base
  include ScopeHelper
  belongs_to  :stock,   class_name: "Core::Stock"
  has_many    :bill_products, class_name: "Core::BillProduct"
  has_many    :logs,  class_name: "Core::StockBillLog"

  validates :identifier, presence: true, length: {maximum: 30}
  validates :stock_id,  presence: true
  validates :cat_name,  presence: true
  validates :customer_name, presence: true, length: {maximum: 30}
  validates :area_id,   presence: true
  validates :address,   presence: true, length: {maximum: 100}  

  STATES = [["待审核", "created"], ["已审核", "audited"], ["已入/出库", "stocked"], ["已取消", "cancled"]]

  def self.find_mine(params)
    find_scope = self
    
    conditions = [[]]

    [:customer_name, :mobile, :address, :phone, :remark].each do |attr|
      if params[attr].blank?
        next
      else
        conditions[0] << "#{attr} LIKE ?"
        conditions << "%#{params[attr]}%"
      end
    end

    [:trade_id, :tid, :cat_name, :status].each do |attr|
      if params[attr].blank?
        next
      else
        conditions[0] << "#{attr} = ?"
        conditions << params[attr]
      end
    end

    conditions[0] = conditions[0].join(" AND ")
    find_scope.where(conditions)
  end

  state_machine :state, :initial => :created do
    event :audit do
      transition :created => :audited
    end

    event :stock do
      transition :audited => :stocked
    end

    event :cancle do
      transition [:created, :audited] => :cancled
    end
  end

  def self.list_shown_attributes
    %w(identifier type_name cat_name_zh state_name updater_name updated_at)
  end

  def self.detail_shown_attributes
    %w(identifier type_name stock_name cat_name_zh state_name customer_name area_id address mobile phone remark updater_name updated_at)
  end

  def stock_name
    stock.try(:name)
  end

  def state_name

  end
end
