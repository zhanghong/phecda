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
  include ScopeHelper

  has_many  :category_properties, class_name: "Sys::CategoryProperty", dependent: :destroy
  has_many  :categories,  through: :category_properties
  has_many      :values,    class_name: "Sys::PropertyValue", dependent: :destroy

  validates :name, presence: true, uniqueness: {scope: [:account_id], conditions: -> { where(deleter_id: 0)}},
            length: {maximum: 20}
  validates :state, presence: true

  STATES = [["启用", "activted"], ["隐藏", "hidden"]]

  def self.find_mine(params)
    find_scope = self
    conditions = [[]]

    params.each do |attr_name, value|
      next if value.blank?
      case attr_name
      when :name
        conditions[0] << "#{attr_name} LIKE ?"
        conditions << "%#{value}%"
      when :state
        conditions[0] << "#{attr_name} = ?"
        conditions << value
      end
    end

    conditions[0] = conditions[0].join(" AND ")
    find_scope.where(conditions)
  end

  def self.list_shown_attributes
    %w(name state_name values_count created_at updated_at)
  end

  def self.detail_shown_attributes
    %w(name state_name created_at updated_at values_name)
  end

  state_machine :state, :initial => :activted do
    event :active do
      transition :hidden => :activted
    end

    event :hide do
      transition :activted => :hidden
    end
  end

  def values_name
    values.map(&:name)
  end

  def values_count
    values.count
  end

  def state_name
    state_item = STATES.find{|s| s.last == self.state}
    if state_item
      state_item.first
    else
      self.state
    end
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
end