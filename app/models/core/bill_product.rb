# encoding : utf-8 -*-
# create_table "core_bill_products", force: true do |t|
#   t.integer  "stock_bill_id",                                     default: 0
#   t.integer  "sys_product_id",                                    default: 0
#   t.integer  "sys_sku_id",                                        default: 0
#   t.string   "sku_name",       limit: 50,                         default: ""
#   t.integer  "number",                                            default: 0
#   t.decimal  "unit_price",                precision: 8, scale: 2
#   t.decimal  "sum_price",                 precision: 8, scale: 2
#   t.integer  "cal_number",                                        default: 0
#   t.decimal  "cal_unit_price",            precision: 8, scale: 2
#   t.decimal  "cal_sum_price",             precision: 8, scale: 2
#   t.integer  "updater_id",                                        default: 0
#   t.datetime "deleted_at"
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
# add_index "core_bill_products", ["stock_bill_id"], name: "idx_by_stock_bill_id", using: :btree
# add_index "core_bill_products", ["sys_sku_id"], name: "idx_by_sys_sku_id", using: :btree
class Core::BillProduct < ActiveRecord::Base
  include ScopeHelper
  belongs_to  :stock_bill,  class_name: "Core::StockBill"
  belongs_to  :sys_product, class_name: "Sys::Product"
  belongs_to  :sys_sku,     class_name: "Sys::Sku"

  validates :stock_bill_id, presence: true
  validates :sys_product_id, presence: true
  validates :sys_sku_id, presence: true
  validates :sku_name, presence: true, length: {maximum: 50}
  validates :number, numericality: {greater_than: 0} 
  validates :unit_price, numericality: {greater_than: 0}

  before_save :calculate_hiddens

  def self.inner_shown_attributes_for_stock_bill
    %w(sku_name number unit_price sum_price updater_name updated_at)
  end

  def bill_identifier
    stock_bill.identifier
  end

  def calculate_hiddens
    if self.stock_bill.is_a?(Core::StockOutBill)
      self.cal_number = 0 - self.number
      self.cal_unit_price = 0 - self.unit_price
    elsif self.stock_bill.is_a?(Core::StockInBill)
      self.cal_number = self.number
      self.cal_unit_price = self.unit_price
    else
      self.cal_number = self.cal_unit_price = 0
    end
    self.sum_price = self.number * self.unit_price
    self.cal_sum_price = self.cal_number * self.cal_unit_price
  end
end
