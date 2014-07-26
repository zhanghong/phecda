# encoding : utf-8 -*-
# create_table "core_user_roles", force: true do |t|
#   t.integer  "account_id",  default: 0
#   t.integer  "user_id",     default: 0
#   t.integer  "role_id",     default: 0
#   t.integer  "updater_id"
#   t.integer  "deleter_id",  default: 0
#   t.datetime "delete_time"
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
# add_index "core_user_roles", ["account_id", "deleter_id", "user_id"], name: "idx_by_account_and_deleter_and_user_id", using: :btree
class Core::UserRoles < ActiveRecord::Base
  include ScopeHelper
  belongs_to  :role,    class_name: "Core::Role"
  belongs_to  :user

  def self.list_shown_attributes
    []
  end

  def self.detail_shown_attributes
    []
  end

    def self.find_mine(params)
    find_scope = self

    conditions = [[]]

    [:updater_id, :user_id, :role_id].each do |attr|
      if params[attr].blank?
        next
      else
        conditions[0] << "#{attr} = ?"
        conditions << "%#{params[attr]}%"
      end
    end

    conditions[0] = conditions[0].join(" AND ")
    find_scope.where(conditions)
  end
  
  def user_name
    user.name
  end

  def role_name
    role.name
  end
end
