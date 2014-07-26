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
  scope :account_scope, -> {where(account_id: Account.current_id)}
  scope :actived, -> {where(deleted_at: nil)}
  has_many  :stock_products, class_name: "Core::StockProduct", dependent: :destroy
  has_many  :sellers, class_name: "Core::Seller", dependent: :destroy
  belongs_to  :updater, class_name: "User"
  belongs_to  :deleter, class_name: "User"

  def self.list_shown_attributes
    %w(name seller_count product_count)
  end

  def self.detail_shown_attributes
    %w(name seller_count product_count updater_name)
  end

  def self.find_mine(params)
    conditions = [[]]

    [:name].each do |attr|
      if params[attr].blank?
        next
      else
        conditions[0] << "#{attr} LIKE ?"
        conditions << "%#{params[attr]}%"
      end
    end

    [:updater_id].each do |attr|
      if params[attr].blank?
        next
      else
        conditions[0] << "#{attr} = ?"
        conditions << "%#{params[attr]}%"
      end
    end

    conditions[0] = conditions[0].join(" AND ")
    account_scope.actived.where(conditions)
  end

  def seller_count
    sellers.count
  end

  def product_count
    stock_products.count
  end

  def updater_name
    updater.name
  end

  def destroy
    update_attributes(deleted_at: Time.now, deleter_id: User.current_id)
  end
end
