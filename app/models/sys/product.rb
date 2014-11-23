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
#   t.integer  "updater_id",                                      default: 0
#   t.integer  "deleter_id",                                      default: 0
# end
# add_index "sys_products", ["category_id"], name: "idx_by_account_id_and_category_id", using: :btree
class Sys::Product < ActiveRecord::Base
  include ScopeHelper
	belongs_to		:category,		class_name: "Sys::Category"
	has_many			:skus,				class_name: "Sys::Sku", dependent: :destroy

  validates :title, presence: true, uniqueness: {scope: [:account_id], conditions: -> { where(deleter_id: 0)}},
            length: {maximum: 100}
  validates :state, presence: true
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0, less_than: 999999.99}

  STATES = [["有效", "activted"], ["隐藏", "hidden"]]

  def self.find_mine(params)
    find_scope = self
    conditions = [[]]

    [:title].each do |attr|
      next if params[attr].blank?
      conditions[0] << "#{attr} LIKE ?"
      conditions << "%#{params[attr]}%"
    end

    [:id, :category_id, :state].each do |attr|
      next if params[attr].blank?
      conditions[0] << "#{attr} = ?"
      conditions << params[attr]
    end

    conditions[0] = conditions[0].join(" AND ")
    find_scope.where(conditions)
  end

  def self.list_shown_attributes
    %w(title price num state_name updater_name)
  end

  def self.detail_shown_attributes
    %w(title category_name num state_name price updater_name created_at updated_at)
  end

  state_machine :state, :initial => :activted do
    event :active do
      transition :hidden => :activted
    end

    event :hide do
      transition :activted => :hidden
    end
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
end
