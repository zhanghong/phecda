# encoding : utf-8 -*-
# create_table "core_role_permissions", force: true do |t|
#   t.integer  "account_id",    default: 0
#   t.integer  "role_id",       default: 0
#   t.integer  "permission_id", default: 0
#   t.integer  "updater_id",    default: 0
#   t.integer  "deleter_id",    default: 0
#   t.datetime "deleted_at"
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
class Core::RolePermission < ActiveRecord::Base
  include ScopeHelper
  belongs_to  :account
  belongs_to  :role,    class_name: "Core::Role"
  belongs_to  :permission,  class_name: "Admin::Permission"
end
