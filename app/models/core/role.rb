# encoding : utf-8 -*-
# create_table "core_roles", force: true do |t|
#   t.integer  "account_id"
#   t.string   "name",       limit: 20, default: ""
#   t.integer  "updater_id",            default: 0
#   t.integer  "deleter_id",            default: 0
#   t.integer  "deleted_at"
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
# add_index "core_roles", ["account_id", "deleter_id"], name: "idx_by_account_id", using: :btree
class Core::Role < ActiveRecord::Base
  include ScopeHelper
  has_many    :core_user_roles,   class_name: "Core::UserRoles",  dependent: :destroy
  has_many    :users,   through: :core_user_roles

  def self.list_shown_attributes
    %w(name)
  end

  def self.detail_shown_attributes
    %w(name updater_name created_at updated_at)
  end

    def self.find_mine(params)
    find_scope = self

    conditions = [[]]

    [:name].each do |attr|
      if params[attr].blank?
        next
      else
        conditions[0] << "#{attr} LIKE ?"
        conditions << "%#{params[attr]}%"
      end
    end

    [:updater_id].each do |attr|
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
end
