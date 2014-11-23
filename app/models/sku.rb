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
#   t.integer  "updater_id",            default: 0
#   t.integer  "shop_id",               default: 0
#   t.integer  "deleter_id",            default: 0
# end
# add_index "skus", ["account_id", "product_id"], name: "idx_by_shop_id_and_product_id", using: :btree
class Sku < ActiveRecord::Base
  scope :account_scope, -> {where(account_id: Account.current_id)}
  scope :activted, -> {where(deleted_at: nil)}

  belongs_to  :account
  belongs_to  :product, class_name: "Tb::Product"
  belongs_to  :updater, class_name: "User"
  belongs_to  :deleter, class_name: "User"

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
    account_scope.activted.where(conditions)
  end

  def updater_name
    updater.name
  end

  def destroy
    update_attributes(deleted_at: Time.now, deleter_id: User.current_id)
  end
end
