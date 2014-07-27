# encoding : utf-8 -*-
# create_table "admin_permissions", force: true do |t|
#   t.string   "module_name",    limit: 20, default: ""
#   t.string   "group_name",     limit: 20, default: ""
#   t.string   "name",           limit: 20, default: ""
#   t.string   "subject_class",  limit: 30, default: ""
#   t.string   "action_name",    limit: 50, default: ""
#   t.string   "ability_method", limit: 50, default: ""
#   t.integer  "sort_num",                  default: 9999
#   t.integer  "updater_id",                default: 0
#   t.integer  "deleter_id",                default: 0
#   t.integer  "deleted_at"
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.string   "tag_name",       limit: 40
#   t.string   "level",          limit: 20, default: ""
#   t.string   "full_name",      limit: 30, default: ""
# end
# add_index "admin_permissions", ["sort_num"], name: "idx_by_sort_num", using: :btree
class Admin::Permission < ActiveRecord::Base
  belongs_to  :updater,   class_name: "User"
  belongs_to  :deleter,   class_name: "User"
  has_many    :account_permissions,   class_name: "Admin::AccountPermission",  dependent: :destroy
  has_many    :accounts,  through: :account_permissions
  has_many    :role_permissions,  class_name: "Core::RolePermission", dependent: :destroy
  has_many    :roles, through: :role_permissions

  validates :module_name, presence: true, length: {maximum: 20}
  validates :group_name, presence: true, length: {maximum: 20}
  validates :level, presence: true, length: {maximum: 20}
  validates :name, presence: true, length: {maximum: 20}
  validates :tag_name, presence: true, length: {maximum: 40}, uniqueness: true
  validates :full_name, presence: true, length: {maximum: 30}, uniqueness: true
  validates :subject_class, presence: true, length: {maximum: 20}
  validates :action_name, presence: true, length: {maximum: 20}
  validates :sort_num, numericality: {greater_than: 0} 

  LEVELS = [["基础", "base"]]

  def self.list_shown_attributes
    %w(full_name module_name group_name)
  end

  def self.detail_shown_attributes
    %w(full_name name tag_name module_name group_name subject_class action_name ability_method sort_num updater_name created_at updated_at)
  end

  def self.find_mine(params)
    find_scope = self

    conditions = [[]]

    [:full_name, :module_name, :group_name].each do |attr|
      if params[attr].blank?
        next
      elsif attr == :full_name
        conditions[0] << "(full_name LIKE ? OR name LIKE ?)"
        conditions << "%#{params[attr]}%" << "%#{params[attr]}%"
      else
        conditions[0] << "#{attr} LIKE ?"
        conditions << "%#{params[attr]}%"
      end
    end

    [:subject_class, :action_name, :updater_id].each do |attr|
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

  def self.account_all_permissions(account_id)
    select_sql = <<-SELECT_SQL
      IF(admin_account_permissions.name IS NULL OR admin_account_permissions.name = '', admin_permissions.name, admin_account_permissions.name) AS name,
      admin_permissions.id AS id, module_name, group_name, sort_num
    SELECT_SQL
    join_sql = <<-JOIN_STR
      INNER JOIN admin_account_permissions ON admin_permissions.id=admin_account_permissions.permission_id
    JOIN_STR
    select(select_sql).joins(join_sql).where(["admin_account_permissions.account_id = ? AND admin_account_permissions.deleter_id=0", account_id])
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
