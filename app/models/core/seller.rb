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
  include ScopeHelper
  has_many  :seller_areas, class_name: "Core::SellerArea", dependent: :destroy
  belongs_to  :stock,       class_name: "Core::Stock"

  validates :name, presence: true, uniqueness: {scope: [:account_id, :deleted_at]},
            length: {maximum: 20}
  validates :fullname, presence: true, uniqueness: {scope: [:account_id, :deleted_at]},
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

    [:name, :mobile, :phone, :email, :stock_name].each do |attr|
      if params[attr].blank?
        next
      elsif attr == :name
        conditions[0] << "core_sellers.name LIKE ?" << "core_sellers.fullname LIKE ?"
        conditions << "%#{params[attr]}%" << "%#{params[attr]}%"
      elsif attr == :stock_name
        conditions[0] << "core_stocks.name LIKE ?"
        conditions << "%#{params[attr]}%"
        find_scope = find_scope.eager_load(:stock)
      end
    end

    [:parent_id, :updater_id].each do |attr|
      if attr == :parent_id
        if params[attr].blank?
          conditions[0] << "core_sellers.parent_id IS NULL"
        else
          conditions[0] << "core_sellers.parent_id = #{params[attr].to_i}"
        end
      elsif params[attr].present?
        conditions[0] << "#{attr} = ?"
        conditions << "%#{params[attr]}%"
      end
    end

    conditions[0] = conditions[0].join(" AND ")
    find_scope.where(conditions)
  end

  def stock_name
    stock.name
  end

  def updater_name
    updater.name
  end

  def parent_name
    parent.try(:name)
  end
end
