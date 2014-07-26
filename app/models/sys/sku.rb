# encoding : utf-8 -*-
# create_table "sys_skus", force: true do |t|
#   t.integer  "account_id",                                    default: 0
#   t.string   "product_id", limit: 30
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.string   "name",       limit: 50,                         default: ""
#   t.datetime "deleted_at"
#   t.integer  "number",                                        default: 0
#   t.decimal  "price",                 precision: 8, scale: 2, default: 0.0
#   t.integer  "updater_id",                                    default: 0
#   t.integer  "deleter_id",                                    default: 0
# end
# add_index "sys_skus", ["account_id", "product_id"], name: "idx_by_account_id_and_product_id", using: :btree
class Sys::Sku < ActiveRecord::Base
	belongs_to		:account
	belongs_to		:product,		class_name: "Sys::Product"
  belongs_to    :updater,   class_name: "User"
  belongs_to    :deleter,   class_name: "User"
  has_many      :sku_bindings,  foreign_key: "sys_sku_id"
  has_many      :skus,      through: :sku_bindings
  has_and_belongs_to_many :property_values, join_table: "sys_sku_property_values", class_name: "Sys::PropertyValue" #, foreign_key: "account_id"

  before_save   :save_property_values

  attr_accessor  :pro_values_ids
  accepts_nested_attributes_for :property_values

  scope :account_scope, -> {where(account_id: Account.current.id)}
  scope :actived, -> {where(deleted_at: nil)}

  validates :name, presence: true, uniqueness: {scope: [:account_id, :deleted_at]},
            length: {maximum: 20}
  validates :number, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}

  def self.detail_shown_attributes
    %w(name product_name number price created_at updated_at property_values_name)
  end

  def self.inner_list_attributes
    %w(name number price property_values_name sku_bindings created_and_updated)
  end

  def self.find_mine(params = {})
    conditions = [[]]

    [:title].each do |attr|
      next if params[attr].blank?
      conditions[0] << "#{attr} LIKE ?"
      conditions << "%#{params[attr]}%"
    end

    [:id, :state].each do |attr|
      next if params[attr].blank?
      conditions[0] << "#{attr} = ?"
      conditions << params[attr]
    end

    conditions[0] = conditions[0].join(" AND ")
    account_scope.actived.where(conditions)
  end

  def destroy
    update_attributes(deleted_at: Time.now)
  end

  def product_name
    self.product.title
  end

  def property_values_ids
    property_values.map(&:id)
  end

  def property_values_name
    property_values.map(&:value_name)
  end

  def updater_name
    updater.name
  end

  def save_property_values
    property_values = if self.pro_values_ids.blank?
                        []
                      else
                        Sys::PropertyValue.account_scope.where(id: self.pro_values_ids)
                      end
    self.property_values = property_values
  end

  def destroy
    update_attributes(deleted_at: Time.now, deleter_id: User.current_id)
  end
end
