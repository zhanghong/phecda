# encoding : utf-8 -*-
# create_table "core_logistics", force: true do |t|
#   t.integer  "account_id"
#   t.string   "name",       limit: 15
#   t.integer  "updater_id"
#   t.datetime "deleted_at"
#   t.integer  "deleter_id"
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
# add_index "core_logistics", ["account_id"], name: "idx_by_account_id", using: :btree
class Core::Logistic < ActiveRecord::Base
  include ScopeHelper
  has_many    :logistic_areas, -> {order("area_id")},  class_name: "Core::LogisticArea", dependent: :destroy
  has_many    :areas,   through: :logistic_areas

  validates :name,  presence: true, uniqueness: {scope: [:account_id], conditions: -> { where(deleter_id: 0)}},
            length: {maximum: 15}

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

  def self.list_shown_attributes
    %w(name updater_name updated_at)
  end

  def self.detail_shown_attributes
    %w(name updater_name created_at updated_at)
  end
end
