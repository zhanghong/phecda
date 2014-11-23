# encoding : utf-8 -*-
# create_table "core_stocks", force: true do |t|
#   t.integer  "account_id",            default: 0
#   t.string   "name",       limit: 50, default: ""
#   t.datetime "deleted_at"
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.integer  "updater_id",            default: 0
#   t.integer  "deleter_id",            default: 0
# end
class Core::Stock < ActiveRecord::Base
  include ScopeHelper
  validates :name,  presence: true, uniqueness: {scope: [:account_id], conditions: -> { where(deleter_id: 0)}},
                    length: {maximum: 20}
  has_many  :stock_products, class_name: "Core::StockProduct", dependent: :destroy
  has_many  :sellers, class_name: "Core::Seller", dependent: :destroy
  has_many  :stock_bills, class_name: "Core::StockBill", dependent: :destroy
  has_many  :stock_in_bills,  class_name: "Core::StockInBill", dependent: :destroy
  has_many  :stock_out_bills, class_name: "Core::StockOutBill", dependent: :destroy

  def self.list_shown_attributes
    %w(name sellers_name product_count)
  end

  def self.detail_shown_attributes
    %w(name product_count updater_name created_at updated_at sellers_name)
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

  def seller_count
    sellers.count
  end

  def stock_product_count
    stock_products.count
  end
end
