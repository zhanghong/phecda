# encoding : utf-8 -*-
# create_table "sys_products", force: true do |t|
#   t.integer  "category_id",                                     default: 0
#   t.string   "title",       limit: 100,                         default: ""
#   t.integer  "num",                                             default: 0
#   t.text     "description"
#   t.integer  "account_id",                                      default: 0
#   t.string   "state",       limit: 20,                          default: "activted"
#   t.decimal  "price",                   precision: 8, scale: 2, default: 0.0
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.datetime "deleted_at"
#   t.integer  "user_id",                                         default: 0
# end
# add_index "sys_products", ["category_id"], name: "idx_by_account_id_and_category_id", using: :btree
class Sys::Product < ActiveRecord::Base
  belongs_to    :user
	belongs_to		:account
	belongs_to		:category,		class_name: "Sys::Category"
	has_many			:skus,					class_name: "Sys::Sku", conditions: "deleted_at IS NULL"

  scope :account_scope, -> {where(account_id: Account.current.id)}
  scope :actived, -> {where(deleted_at: nil)}

  STATES = [["有效", "activted"], ["隐藏", "hidden"]]

  def self.find_mine(params)
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

  def self.list_shown_attributes
    %w(title price num state_name user_name)
  end

  def self.detail_shown_attributes
    %w(title category_name num state_name price created_at updated_at)
  end

  def state_name
    state_item = STATES.find{|s| s.last == state}
    if state_item
      state_item.first
    else
      state
    end
  end

  def category_name
    self.category.try(:name)
  end

  def user_name
    self.user.name
  end

  def destroy
    update_attributes(deleted_at: Time.now)
  end
end
