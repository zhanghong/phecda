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
  include ScopeHelper
  
	belongs_to	:property,		class_name: "Sys::Property"
  has_and_belongs_to_many :skus, join_table: "sys_sku_property_values"

  validates :name, presence: true, uniqueness: {scope: [:property_id], conditions: -> { where(deleter_id: 0)}},
            length: {maximum: 20}

  def value_name
    "#{property.name}:#{self.name}"
  end
end
