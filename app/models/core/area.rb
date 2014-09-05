# encoding : utf-8 -*-
# create_table "core_areas", force: true do |t|
#   t.string   "taobao_name",    limit: 20, default: ""
#   t.integer  "parent_id"
#   t.boolean  "active",                    default: true
#   t.string   "pinyin",         limit: 50, default: ""
#   t.integer  "children_count",            default: 0
#   t.integer  "lft",                       default: 0
#   t.integer  "rgt",                       default: 0
#   t.integer  "area_type"
#   t.string   "zip",            limit: 6,  default: ""
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.integer  "updater_id",                default: 0
#   t.integer  "level_id"
#   t.integer  "taobao_id",                 default: 0
#   t.integer  "jingdong_id",               default: 0
#   t.string   "jingdong_name",  limit: 20, default: ""
# end
class Core::Area < ActiveRecord::Base
  acts_as_nested_set counter_cache: :children_count
  has_many  :seller_areas, class_name: "Core::SellerArea", dependent: :destroy
  has_many  :logistic_areas,  class_name: "Core::LogisticArea", dependent: :destroy
  belongs_to  :updater,     class_name: "User"

  def self.list_shown_attributes
    %w(zipcode province_name city_name state_name)
  end

  def self.detail_shown_attributes
    %w(zipcode province_name city_name state_name)
  end

  def self.find_mine(params)
    find_scope = self

    #conditions = [["level_id = ?"], 3]
    conditions = [[]]

    params.each do |attr_name, value|
      next if value.blank?
      case attr_name
      when :name
        conditions[0] << "(taobao_name LIKE ? OR jingdong_name LIKE ?)"
        conditions << "%#{value}%" << "%#{value}%"
      when :parent_id
        conditions[0] << "parent_id = #{value.to_i}"
      end
    end

    conditions[0] = conditions[0].join(" AND ")
    find_scope.where(conditions)
  end

  #更新Core::Area的级别
  def self.reset_levels
    self.roots.to_a.each do |area|
      set_level_id(area, 1)
    end
  end

  def self.node_with_children(node)
    items = [node]
    node.children.each do |child|
      items += node_with_children(child)
    end

    items
  end

  def name
    if self.taobao_name.present?
      self.taobao_name
    elsif self.jingdong_name.present?
      self.jingdong_name
    else
      ""
    end
  end

  def province_name
    case self.level_id
    when 1
      self.name
    when 2
      parent.name
    when 3
      parent.parent.name
    else
      ""
    end
  end

  def city_name
    case self.level_id
    when 1
      ""
    when 2
      name
    when 3
      parent.name
    else
      ""
    end
  end

  def state_name
    case self.level_id
    when 1
      ""
    when 2
      ""
    when 3
      self.name
    else
      ""
    end
  end

  def full_name
    [province_name, city_name, state_name].delete_if{|n| n.blank?}.join("-")
  end
  
  def is_leaf
    children.count == 0
  end
private
  def self.set_level_id(area, level_id)
    area.update(level_id: level_id)
    area.children.each do |child|
      set_level_id(child, level_id + 1)
    end
  end
end
