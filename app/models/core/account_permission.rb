# encoding : utf-8 -*-
# create_table "core_account_permissions", force: true do |t|
#   t.integer  "account_id",    default: 0
#   t.integer  "permission_id", default: 0
#   t.integer  "updater_id",    default: 0
#   t.integer  "deleter_id",    default: 0
#   t.datetime "deleted_at"
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
# add_index "core_account_permissions", ["account_id", "deleter_id"], name: "idx_by_account_id_and_deleter_id", using: :btree
class Core::AccountPermission < ActiveRecord::Base
  include ScopeHelper
  belongs_to    :permission,  class_name: "Core::Permission"

  def self.list_shown_attributes
    []
  end

  def self.detail_shown_attributes
    []
  end

  def self.find_mine(params)
    find_scope = self

    conditions = [[]]

    [:permission_name].each do |attr|
      if params[attr].blank?
        next
      elsif attr == :permission_name
        conditions[0] << "core_permissions.#{attr} LIKE ?"
        conditions << "%#{params[attr]}%"
        find_scope = find_scope.eager_load(:permission)
      end
    end

    [:updater_id].each do |attr|
      if params[attr].blank?
        next
      else
        conditions[0] << "core_account_permissions.#{attr} = ?"
        conditions << "%#{params[attr]}%"
      end
    end

    conditions[0] = conditions[0].join(" AND ")
    find_scope.where(conditions)
  end

  def permission_name
    permission.name
  end
end
