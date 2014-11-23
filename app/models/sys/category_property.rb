# encoding : utf-8 -*-
# create_table "sys_categories_properties", force: true do |t|
#   t.integer  "category_id"
#   t.integer  "property_id"
#   t.integer  "account_id",  default: 0
#   t.integer  "updater_id",  default: 0
#   t.datetime "deleted_at"
#   t.integer  "deleter_id",  default: 0
# end
class Sys::CategoryProperty < ActiveRecord::Base
  self.table_name = "sys_categories_properties"
  include ScopeHelper
  belongs_to  :category,  class_name: "Sys::Category"
  belongs_to  :property,  class_name: "Sys::Property"
end
