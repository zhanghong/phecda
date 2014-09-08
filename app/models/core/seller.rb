# encoding : utf-8 -*-
# create_table "core_sellers", force: true do |t|
#   t.integer  "account_id"
#   t.integer  "parent_id"
#   t.integer  "updater_id"
#   t.string   "name",           limit: 20, default: ""
#   t.string   "fullname",       limit: 50, default: ""
#   t.string   "mobile",         limit: 50, default: ""
#   t.string   "phone",          limit: 50, default: ""
#   t.string   "email"
#   t.string   "address",        limit: 50, default: ""
#   t.integer  "lft",                       default: 0
#   t.integer  "rgt",                       default: 0
#   t.integer  "children_count",            default: 0
#   t.string   "pinyin"
#   t.integer  "stock_id",                  default: 0
#   t.datetime "deleted_at"
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.integer  "deleter_id",                default: 0
# end
class Core::Seller < ActiveRecord::Base
  acts_as_nested_set counter_cache: :children_count
  include ScopeHelper
  has_many  :seller_areas, class_name: "Core::SellerArea", dependent: :destroy
  belongs_to  :stock,       class_name: "Core::Stock"

  # validates :name, presence: true, uniqueness: {scope: [:account_id, :deleted_at]},
  #           length: {maximum: 20}
  # validates :fullname, presence: true, uniqueness: {scope: [:account_id, :deleted_at]},
  #           length: {maximum: 50}
  validates :name, presence: true, uniqueness: {scope: [:account_id], conditions: -> { where(deleter_id: 0)}},
            length: {maximum: 20}
  validates :fullname, presence: true, uniqueness: {scope: [:account_id], conditions: -> { where(deleter_id: 0)}},
            length: {maximum: 50}
  validates :mobile, presence: true
  validates :email, presence: true
  validates :stock_id, presence: true

  def self.list_shown_attributes
    %w(name stock_name mobile phone email)
  end

  def self.detail_shown_attributes
    %w(name fullname stock_name mobile phone email address updater_name updated_at)
  end

  def self.find_mine(params)
    find_scope = self

    conditions = [[]]

    params.each do |attr_name, value|
      next if value.blank?
      case attr_name
      when :name
        conditions[0] << "core_sellers.name LIKE ? OR core_sellers.fullname LIKE ?"
        conditions << "%#{value}%" << "%#{value}%"
      when :mobile, :phone, :email
        conditions[0] << "core_sellers.#{attr_name} LIKE ?"
        conditions << "%#{value}%"
      when :stock_name
        conditions[0] << "core_stocks.name LIKE ?"
        conditions << "%#{value}%"
        find_scope = find_scope.eager_load(:stock)
      when :updater_id
        conditions[0] << "core_sellers.#{attr_name} = ?"
        conditions << value.to_i
      when :parent_id
        val = value.to_i
        if val > 0
          conditions[0] << "core_sellers.parent_id = ?"
          conditions << val
        else
          conditions[0] << "core_sellers.parent_id IS NULL"
        end
      end
    end

    conditions[0] = conditions[0].join(" AND ")
    find_scope.where(conditions)
  end

  def stock_name
    stock.try(:name)
  end

  def parent_name
    parent.try(:name)
  end
end
