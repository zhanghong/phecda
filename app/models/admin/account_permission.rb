# encoding : utf-8 -*-
# create_table "admin_account_permissions", force: true do |t|
#   t.integer  "account_id",    default: 0
#   t.integer  "permission_id", default: 0
#   t.integer  "updater_id",    default: 0
#   t.integer  "deleter_id",    default: 0
#   t.datetime "deleted_at"
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
# add_index "admin_account_permissions", ["account_id", "deleter_id"], name: "idx_by_account_id_and_deleter_id", using: :btree

class Admin::AccountPermission < ActiveRecord::Base
  default_scope -> { where(deleter_id: 0)}
  belongs_to  :account
  belongs_to  :permission,  class_name: "Admin::Permission"
  belongs_to  :updater,   class_name: "User"
  belongs_to  :deleter,   class_name: "User"

  validates :account_id,  presence: true

  def self.list_shown_attributes
    %w(account_name joined_at granted_at)
  end

  def self.detail_shown_attributes
    []
  end

  def self.inner_shown_attributes_for_admin_permission
    %w(account_name granted_at)
  end

  def self.find_mine(params)
    find_scope = self.joins(:permission, :account)

    conditions = [["admin_permissions.deleter_id = ?"], 0]

    [:permission_name, :account_name].each do |attr|
      if params[attr].blank?
        next
      elsif attr == :permission_name
        conditions[0] << "(admin_permissions.name LIKE ? OR admin_permissions.full_name LIKE ?)"
        conditions << "%#{params[attr]}%" << "%#{params[attr]}%"
      elsif attr == :account_name
        conditions[0] << "accounts.name LIKE ?"
        conditions << "%#{params[attr]}%"
      end
    end

    [:updater_id].each do |attr|
      if params[attr].blank?
        next
      else
        conditions[0] << "admin_account_permissions.#{attr} = ?"
        conditions << params[attr]
      end
    end

    conditions[0] = conditions[0].join(" AND ")
    find_scope.where(conditions).order("admin_permissions.sort_num")
  end

  def self.account_group_find(params)
    find_mine(params).group("admin_account_permissions.account_id")
  end

  def permission_name
    if self.name.blank?
      permission.name
    else
      self.name
    end
  end

  def account_name
    account.try(:name)
  end

  def joined_at
    account.try(:created_at)
  end

  def granted_at
    updated_at
  end

  def updater_name
    updater.try(:name)
  end

  def deleter_name
    deleter.try(:name)
  end

  def destroy
    update_attributes!(deleted_at: Time.now, deleter_id: User.current_id)
  end
end
