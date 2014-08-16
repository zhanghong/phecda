# encoding : utf-8 -*-
# create_table "core_stock_bill_logs", force: true do |t|
#   t.integer  "stock_bill_id",            default: 0
#   t.string   "status",        limit: 40, default: ""
#   t.integer  "updater_id",               default: 0
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
# add_index "core_stock_bill_logs", ["stock_bill_id"], name: "idx_by_stock_bill_id", using: :btree
class Core::StockBillLog < ActiveRecord::Base
  belongs_to  :stock_bill,    class_name: "Core::StockBill"
  belongs_to  :updater,       class_name: "User"

  def self.inner_shown_attributes_for_stock_bill
    %w(state updater_name created_at)
  end

  def updater_name
    updater.try(:name)
  end

  def bill_identifier
    stock_bill.identifier
  end
end
