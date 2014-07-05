# encoding : utf-8 -*-
# create_table "sku_bindings", force: true do |t|
#   t.integer  "sku_id"
#   t.integer  "sys_sku_id"
#   t.integer  "sys_sku_number"
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.integer  "account_id",     default: 0
#   t.integer  "user_id",        default: 0
# end
class SkuBinding < ActiveRecord::Base
  belongs_to  :sku
  belongs_to  :sys_sku,   class_name: "Sys::Sku"
  belongs_to  :user
  belongs_to  :account

  validates :sku_id,  presence: true, uniqueness: {scope: [:sys_sku_id]}
  validates :sys_sku_id,  presence: true, uniqueness: {scope: [:sku_id]}
  validates :sys_sku_number, numericality: {greater_than: 0} 

  def self.detail_shown_attributes
    %w(sku_name sys_sku_name sys_sku_number created_at updated_at)
  end

  def self.inner_shown_attributes_for_sys_sku
    %w(sku_name sys_sku_number user_name created_and_updated)
  end

  def sys_sku_name
    sys_sku.try(:name)
  end

  def sku_name
    sku.full_name
  end

  def for_sys_sku_name
    "(x#{self.sys_sku_number})=#{sku_name}"
  end

  def for_sku_name
    "#{sys_sku_name}x#{self.sys_sku_number}"
  end

  def user_name
    self.user.name
  end
end
