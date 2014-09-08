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
  validates :name,  presence: true, uniqueness: {scope: [:account_id], conditions: -> { where(deleter_id: 0)}},
                    length: {maximum: 20}

  has_many    :user_roles,   class_name: "Core::UserRole",  dependent: :destroy
  has_many    :users,   through: :user_roles
  has_many    :role_permissions, -> {where(deleter_id: 0)},  class_name: "Core::RolePermission", dependent: :destroy

  attr_accessor :permisson_ids

  after_save  :save_role_permissions

  def self.list_shown_attributes
    %w(name user_count updated_at)
  end

  def self.detail_shown_attributes
    %w(name updater_name created_at updated_at)
  end

  def self.find_mine(params)
    find_scope = self

    conditions = [[]]

    params.each do |attr_name, value|
      next if value.blank?
      case attr_name
      when :name
        conditions[0] << "#{attr_name} LIKE ?"
        conditions << "%#{value}%"
      when :updater_id
        conditions[0] << "#{attr_name} = ?"
        conditions << value.to_i
      end
    end

    conditions[0] = conditions[0].join(" AND ")
    find_scope.where(conditions)
  end

  def user_count
    user_roles.count
  end
private
  def save_role_permissions
    if self.permisson_ids.is_a?(Array)
      new_pmt_ids = permisson_ids.collect{|item| item.to_i}.select{|i| i > 0}
      old_pmt_ids = self.role_permissions.map(&:permission_id)

      added_pmt_ids = new_pmt_ids - old_pmt_ids
      Admin::Permission.where(id: added_pmt_ids).each do |permission|
        role_permissions.create(account_id: self.account_id, permission_id: permission.id, updater_id: User.current_id)
      end if added_pmt_ids.present?

      delete_pmt_ids = old_pmt_ids - new_pmt_ids
      Core::RolePermission.destroy_all(role_id: self.id, permission_id: delete_pmt_ids) if delete_pmt_ids.present?
    end
  end
end
