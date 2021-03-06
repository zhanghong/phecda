# encoding : utf-8 -*-
# create_table "accounts", force: true do |t|
#   t.string   "name",       limit: 30, default: ""
#   t.string   "phone",      limit: 13, default: ""
#   t.string   "email",      limit: 50, default: ""
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
class Account < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: "users_accounts"#, foreign_key: "account_id"
  has_many  :account_permissions, class_name: "Admin::AccountPermission", dependent: :destroy
  has_many  :roles, class_name: "Core::Role", dependent: :destroy
  has_many  :role_permissions,  class_name: "Core::RolePermission", dependent: :destroy
  has_many  :shops, dependent: :destroy
  has_many  :sellers, dependent: :destroy

  def self.current=(account)
    Thread.current[:current_account] = account
  end

  def self.current
    Thread.current[:current_account]
  end

  def self.current_id
    if self.current.nil?
      -1
    else
      self.current.id
    end
  end

  #给店铺开启base访问权限
  def grant_base_to_account
    all_base_ids = Admin::Permission.where(level: "base").map(&:id)
    granted_ids = Admin::AccountPermission.where(account_id: account_id).map(&:permission_id)
    (all_base_ids - granted_ids).each do |pmt_id|
      Admin::AccountPermission.create(account_id: account_id, permission_id: pmt_id)
    end
  end

  #给店铺创建默认角色
  def create_default_roles
    all_pmt_ids = Admin::Permission.account_all_permissions(self.id).map(&:id)
    super_admin = User.where(is_superadmin: true).first

    admin_role = Core::Role.unscoped.find_or_initialize_by(account_id: self.id, name: "管理员")
    admin_role.update(updater_id: super_admin.id, permisson_ids: all_pmt_ids) if admin_role.new_record?
    User.where(is_superadmin: true).each do |user|
      user_role = Core::UserRoles.find_or_initialize_by(account_id: self.id, role_id: admin_role.id, user_id: user.id)
      user_role.update(updater_id: super_admin.id) if user_role.new_record?
    end unless admin_role.new_record?
  end
private
  def add_to_superadmin
    User.add_shop_to_superadmins(self)
  end
end
