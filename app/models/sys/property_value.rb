# encoding : utf-8 -*-
# create_table "sys_property_values", force: true do |t|
#   t.integer  "account_id",             default: 0
#   t.integer  "property_id",            default: 0
#   t.string   "name",        limit: 20, default: ""
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.datetime "deleted_at"
#   t.integer  "updater_id",             default: 0
#   t.integer  "deleter_id",             default: 0
# end
# add_index "sys_property_values", ["account_id", "property_id"], name: "idx_by_account_id_and_property_id", using: :btree
class Sys::PropertyValue < ActiveRecord::Base
  scope :account_scope, -> {where(account_id: Account.current_id)}
  scope :actived, -> {where(deleted_at: nil)}
  
	belongs_to	:account
	belongs_to	:property,		class_name: "Sys::Property"
  belongs_to  :updater,     class_name: "User"
  belongs_to  :deleter,     class_name: "User"
  has_and_belongs_to_many :skus, join_table: "sys_sku_property_values"
  scope :account_scope, -> {where(account_id: Account.current.id)}

  def value_name
    "#{property.name}:#{self.name}"
  end

  def updater_name
    updater.name
  end

  def destroy
    update_attributes(deleted_at: Time.now, deleter_id: User.current_id)
  end
end
