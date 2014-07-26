# encoding : utf-8 -*-
# create_table "sys_sku_property_values", force: true do |t|
#   t.integer  "sku_id",            default: 0
#   t.integer  "property_value_id", default: 0
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.integer  "account_id",        default: 0
#   t.integer  "updater_id",        default: 0
#   t.datetime "deleted_at"
#   t.integer  "deleter_id",        default: 0
# end
# add_index "sys_sku_property_values", ["sku_id", "property_value_id"], name: "idx_by_sku_id_and_property_id", using: :btree
class Sys::SkuPropertyValue < ActiveRecord::Base
  scope :account_scope, -> {where(account_id: Account.current_id)}
  scope :actived, -> {where(deleted_at: nil)}

	belongs_to	:sku,		class_name: "Sys::Sku"
	belongs_to	:property_value,		class_name: "Sys::PropertyValue"
  belongs_to  :updater,           class_name: "User"
  belongs_to  :deleter,           class_name: "User"

  def updater_name
    updater.name
  end

  def destroy
    update_attributes(deleted_at: Time.now, deleter_id: User.current_id)
  end
end
