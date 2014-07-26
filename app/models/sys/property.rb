# encoding : utf-8 -*-
# create_table "sys_properties", force: true do |t|
#   t.integer  "account_id",            default: 0
#   t.string   "name",       limit: 30, default: ""
#   t.string   "status",     limit: 20, default: ""
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.datetime "deleted_at"
#   t.integer  "updater_id",            default: 0
#   t.integer  "deleter_id",            default: 0
# end
# add_index "sys_properties", ["account_id", "name"], name: "idx_by_account_id_and_name", using: :btree
# add_index "sys_properties", ["account_id", "status"], name: "idx_by_account_id_and_status", using: :btree
class Sys::Property < ActiveRecord::Base
  scope :account_scope, -> {where(account_id: Account.current_id)}
  scope :actived, -> {where(deleted_at: nil)}

  has_and_belongs_to_many :categories, join_table: "sys_categories_properties", class_name: "Sys::Category"
	belongs_to		:account
  belongs_to    :updater,   class_name: "User"
  belongs_to    :deleter,   class_name: "User"
  has_many      :values,    class_name: "Sys::PropertyValue"
  

  STATUS = [["启用", "actived"], ["隐藏", "hidden"]]

  def self.find_mine(params)
    conditions = [[]]

    [:name].each do |attr|
      next if params[attr].blank?
      conditions[0] << "#{attr} LIKE ?"
      conditions << "%#{params[attr]}%"
    end

    [:state].each do |attr|
      next if params[attr].blank?
      conditions[0] << "#{attr} = ?"
      conditions << params[attr]
    end

    conditions[0] = conditions[0].join(" AND ")
    account_scope.actived.where(conditions)
  end

  def self.list_shown_attributes
    %w(name status_name values_count created_at updated_at)
  end

  def self.detail_shown_attributes
    %w(name status_name created_at updated_at values_name)
  end

  def self.account_properties
    account_scope.actived
  end

  def values_name
    values.map(&:name)
  end

  def values_count
    values.count
  end

  def status_name
    status_item = STATUS.find{|s| s.last == self.status}
    if status_item
      status_item.first
    else
      self.status
    end
  end

  def updater_name
    updater.name
  end

  def save_property_values(values_name)
    current_name= []
    values_name.to_s.split(/\r|\n/).each do |name|
      name = name.strip
      next if name.blank?
      Sys::PropertyValue.find_or_create_by(account_id: self.account_id, property_id: self.id, name: name)
      current_name << name
    end
    if current_name.present?
      self.values.where(["name NOT IN (?)", current_name]).destroy_all
    else
      self.values.destroy_all
    end
  end

  def destroy
    self.categories = []
    update_attributes(deleted_at: Time.now, deleter_id: User.current_id)
  end
end