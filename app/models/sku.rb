# encoding : utf-8 -*-
# create_table "skus", force: true do |t|
#   t.integer  "account_id",            default: 0
#   t.integer  "product_id",            default: 0
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.integer  "quantity",              default: 0
#   t.string   "ts_id",      limit: 30, default: ""
#   t.boolean  "is_hide",               default: false
#   t.string   "type",                  default: "20"
#   t.datetime "deleted_at"
#   t.integer  "user_id",               default: 0
# end
# add_index "skus", ["account_id", "product_id"], name: "idx_by_shop_id_and_product_id", using: :btree
class Sku < ActiveRecord::Base
  belongs_to  :shop,  class_name: "Tb::Shop"
  belongs_to  :product, class_name: "Tb::Product"

  scope :account_scope, -> {where(account_id: Account.current.id)}
  scope :actived, -> {where(deleted_at: nil)}

  def self.find_mine(params = {})
    conditions = [[]]

    [:title].each do |attr|
      next if params[attr].blank?
      conditions[0] << "#{attr} LIKE ?"
      conditions << "%#{params[attr]}%"
    end

    [:id, :state].each do |attr|
      next if params[attr].blank?
      conditions[0] << "#{attr} = ?"
      conditions << params[attr]
    end

    conditions[0] = conditions[0].join(" AND ")
    account_scope.actived.where(conditions)
  end

  def destroy
    update_attributes(deleted_at: Time.now)
  end
end
