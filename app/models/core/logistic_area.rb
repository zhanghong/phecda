# encoding : utf-8 -*-
# create_table "core_logistic_areas", force: true do |t|
#   t.integer  "account_id"
#   t.integer  "logistic_id"
#   t.integer  "area_id"
#   t.integer  "updater_id"
#   t.datetime "deleted_at"
#   t.integer  "deleter_id"
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
# add_index "core_logistic_areas", ["account_id", "aera_id"], name: "idx_by_account_id_and_area_id", using: :btree
class Core::LogisticArea < ActiveRecord::Base
  include ScopeHelper
  belongs_to  :logistic,  class_name: "Core::Logistic"
  belongs_to  :area,      class_name: "Core::Area"

  validates :logistic_id,  presence: true, uniqueness: {scope: [:area_id], conditions: -> { where(deleter_id: 0)}}
  validates :area_id,  presence: true, uniqueness: {scope: [:logistic_id], conditions: -> { where(deleter_id: 0)}}

  def self.inner_shown_attributes_for_core_logistic
    %w(area_zipcode area_province_name area_city_name area_state_name)
  end

  def self.inner_shown_attributes_for_core_area
    %w(logistic_name)
  end

  def self.find_mine(params)
    find_scope = self.eager_load(:logistic, :area)

    conditions = [[]]

    params.each do |attr_name, value|
      next if value.blank?
      case attr_name
      when :logistic_name
        conditions[0] << "core_logistics.name LIKE ?"
        conditions << "%#{value}%"
      when :parent_id
        parent_id = value.to_i
        area_ids = [parent_id]
        area_ids += Core::Area.where(parent_id: parent_id).map(&:id)
        conditions[0] << "core_logistic_areas.area_id IN (?)"
        conditions << area_ids
      when :area_id, :logistic_id
        if value.is_a?(Array)
          conditions[0] << "core_logistic_areas.#{attr_name} IN (?)"
          conditions << value
        else
          conditions[0] << "core_logistic_areas.#{attr_name}=?"
          conditions << value.to_i
        end
      when :updater_id
        conditions[0] << "core_logistic_areas.#{attr_name}=?"
        conditions << value.to_i
      end
    end

    conditions[0] = conditions[0].join(" AND ")
    find_scope.where(conditions)
  end

   def self.check_node(logistic_id, area_id, is_checked)
    logistic = Core::Logistic.find_by_id(logistic_id)
    area = Core::Area.find_by_id(area_id)
    return if logistic.nil? || area.nil?
    node_ids = Core::Area.node_with_children(area).map(&:id)
    if is_checked == true
      area_ids = find_mine(area_id: node_ids).map(&:area_id)
      (node_ids - area_ids).each do |node_id|
        create(logistic_id: logistic_id, area_id: node_id, updater_id: User.current_id)
      end
    else
      destroy_all(logistic_id: logistic_id, area_id: node_ids)
    end
  end

  def logistic_name
    logistic.name
  end

  def area_zipcode
    area.zipcode
  end

  def area_province_name
    area.province_name
  end

  def area_city_name
    area.city_name
  end

  def area_state_name
    area.state_name
  end
end
