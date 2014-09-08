# encoding : utf-8 -*-
# create_table "core_user_roles", force: true do |t|
#   t.integer  "account_id", default: 0
#   t.integer  "user_id",    default: 0
#   t.integer  "role_id",    default: 0
#   t.integer  "updater_id"
#   t.integer  "deleter_id", default: 0
#   t.datetime "deleted_at"
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
# add_index "core_user_roles", ["account_id", "deleter_id", "user_id"], name: "idx_by_account_and_deleter_and_user_id", using: :btree
class Core::UserRole < ActiveRecord::Base
  include ScopeHelper
  belongs_to  :role,    class_name: "Core::Role"
  belongs_to  :user

  validates :role_id,  presence: true, uniqueness: {scope: [:user_id], conditions: -> { where(deleter_id: 0)}}
  validates :user_id,  presence: true, uniqueness: {scope: [:role_id], conditions: -> { where(deleter_id: 0)}}

  def self.list_shown_attributes
    []
  end

  def self.detail_shown_attributes
    []
  end

  def self.find_mine(params)
    find_scope = self

    conditions = [[]]

    params.each do |attr_name, value|
      next if value.blank?
      case attr_name
      when :updater_id, :user_id, :role_id
        conditions[0] << "#{attr_name} = ?"
        conditions << value.to_i
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
