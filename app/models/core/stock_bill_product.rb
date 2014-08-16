# encoding : utf-8 -*-
# create_table "core_stock_bill_products", force: true do |t|
#   t.integer  "stock_bill_id",                          default: 0
#   t.integer  "sys_product_id",                         default: 0
#   t.integer  "sys_sku_id",                             default: 0
#   t.integer  "number",                                 default: 0
#   t.integer  "autual_number",                          default: 0
#   t.decimal  "unit_price",     precision: 8, scale: 2
#   t.decimal  "sum_price",      precision: 8, scale: 2
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
# add_index "core_stock_bill_products", ["stock_bill_id"], name: "idx_by_stock_bill_id", using: :btree
class Core::StockBillProduct < ActiveRecord::Base
  belongs_to  :stock_bill,  class_name: "Core::StockBill"
  before_save :set_auction_number

private
  def set_auction_number
    if self.stock_bill.is_a?(Core::StockOutBill)
      self.auction_number = 0 - self.number
    elsif elf.stock_bill.is_a?(Core::StockInBill)
      self.auction_number = self.number
    end
  end
end
