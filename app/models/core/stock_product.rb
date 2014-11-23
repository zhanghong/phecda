# encoding : utf-8 -*-
# create_table "core_stock_products", force: true do |t|
#   t.integer  "account_id",     default: 0
#   t.integer  "stock_id",       default: 0
#   t.integer  "sys_product_id", default: 0
#   t.integer  "sys_sku_id",     default: 0
#   t.integer  "activite_num",   default: 0
#   t.integer  "actual_num",     default: 0
#   t.datetime "deleted_at"
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.integer  "updater_id",     default: 0
#   t.integer  "deleter_id",     default: 0
# end
class Core::StockProduct < ActiveRecord::Base
  scope :account_scope, -> {where(account_id: Account.current_id)}
  scope :activted, -> {where(deleted_at: nil)}

  belongs_to  :stock, class_name: "Core::Stock"
  belongs_to  :product, class_name: "Sys::Product", foreign_key: "sys_product_id"
  belongs_to  :sku,     class_name: "Sys::Sku", foreign_key: "sys_sku_id"
  belongs_to  :updater, class_name: "User"
  belongs_to  :deleter, class_name: "User"

  def self.list_shown_attributes
    %w(product_name sku_name activite_num actual_num)
  end

  def self.detail_shown_attributes
    %w(product_name sku_name activite_num actual_num)
  end

  def self.find_mine(params)
    find_scope = account_scope.activted
    conditions = [[]]

    [:product_name].each do |attr|
      if params[attr].blank?
        next
      elsif attr == :product_name
        conditions[0] << "sys_products.title LIKE ?" << "sys_skus.name LIKE ?"
        conditions << "%#{params[attr]}%" << "%#{params[attr]}%"
        find_scope = find_scope.eager_load(:product, :sku)
      end
    end

    [:activite_num, :actual_num].each do |attr|
      next if params[attr].blank?
      conditions[0] << "core_stock_products.#{attr} = ?"
      conditions << params[attr]
    end

    conditions[0] = conditions[0].join(" AND ")
    find_scope.where(conditions)
  end

  def product_name
    product.try(:name)
  end

  def sku_name
    sku.name
  end

  def updater_name
    updater.name
  end

  def destroy
    update_attributes(deleted_at: Time.now, deleter_id: User.current_id)
  end
end
