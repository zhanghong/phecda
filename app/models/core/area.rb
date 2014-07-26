# encoding : utf-8 -*-
# create_table "core_areas", id: false, force: true do |t|
#   t.integer  "id"
#   t.string   "name",           limit: 20, default: ""
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

    [:name].each do |attr|
      if params[attr].blank?
        next
      else
        conditions[0] << "#{attr} LIKE ?"
        conditions << "%#{params[attr]}%"
      end
    end

    [:parent_id].each do |attr|
      if attr == :parent_id
        if params[attr].blank?
          conditions[0] << "parent_id IS NULL"
        else
          conditions[0] << "parent_id = #{params[attr].to_i}"
        end
      elsif params[attr].blank?
        next
      else
        conditions[0] << "#{attr} = ?"
        conditions << params[attr]
      end
    end

    conditions[0] = conditions[0].join(" AND ")
    find_scope.where(conditions)
  end

  def self.reset_levels
    self.roots.each do |area|
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

  def zipcode
    self.id
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
    self.children_count > 0
  end
private
  def self.set_level_id(area, level_id)
    area.children.each do |child|
      set_level_id(child, level_id + 1)
    end
    area.update(level_id: level_id)
  end
end
