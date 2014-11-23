# encoding : utf-8 -*-
# create_table "sys_categories", force: true do |t|
#   t.string   "name",              limit: 30, default: ""
#   t.integer  "account_id",                   default: 0
#   t.string   "state",                        default: "actived"
#   t.integer  "parent_id",                    default: 0
#   t.integer  "lft",                          default: 0
#   t.integer  "rgt",                          default: 0
#   t.integer  "depth",                        default: 0
#   t.integer  "use_days",                     default: 1
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.string   "pic_url",                      default: ""
#   t.integer  "sort_order"
#   t.integer  "taobao_id",                    default: 0
#   t.datetime "taobao_updated_at"
#   t.datetime "deleted_at"
#   t.integer  "children_count",               default: 0
#   t.integer  "updater_id",                   default: 0
#   t.integer  "deleter_id",                   default: 0
# end
class Sys::Category < ActiveRecord::Base
  include ScopeHelper
  has_many  :category_properties, class_name: "Sys::CategoryProperty", dependent: :destroy
  has_many  :properties,  through: :category_properties

  validates :name, presence: true, uniqueness: {scope: [:account_id], conditions: -> { where(deleter_id: 0)}},
            length: {maximum: 20}
  validates :state, presence: true

  acts_as_nested_set :counter_cache => :children_count

  STATES = [["启用", "actived"], ["隐藏", "hidden"]]

  def self.find_mine(params)
    find_scope = self
    conditions = [[]]

    params.each do |attr_name, value|
      next if value.blank?
      case attr_name
      when :name
        conditions[0] << "#{attr_name} LIKE ?"
        conditions << "%#{value}%"
      when :parent_id
        conditions[0] << "#{attr_name} = ?"
        conditions << value.to_i
      when :state
        conditions[0] << "#{attr_name} = ?"
        conditions << value
      end
    end

    conditions[0] = conditions[0].join(" AND ")
    find_scope.where(conditions)
  end

  # def self.sync_to_taobao
  #   self.all.each do |category|
  #     category.sync_to_taobao
  #   end
  # end

  def self.list_shown_attributes
    %w(name status_name parent_name created_at updated_at)
  end

  def self.detail_shown_attributes
    %w(name status_name created_at updated_at parent_name children_name properties_name)
  end

  # def self.account_roots
  #   account_scope.actived.roots
  # end

  # def sync_to_taobao
  #   response = TaobaoFu.get(method: 'taobao.sellercats.list.add',
  #                  name: self.name,
  #                  pict_url: self.pic_url,
  #                  parent_cid: self.parent_id
  #              )
  #   seller_cat = response["sellercats_list_add_response"]["seller_cat"] rescue {}
  #   if seller_cat.present?
  #     self.update(taobao_id: seller_cat["cid"], taobao_updated_at: seller_cat["created"])
  #   end
  # end

  state_machine :state, :initial => :actived do
    event :active do
      transition :hidden => :actived
    end

    event :hide do
      transition :actived => :hidden
    end
  end

  def state_name
    state_item = STATES.find{|s| s.last == self.state}
    if state_item
      state_item.first
    else
      self.state
    end
  end

  def parent_name
    parent.try(:name)
  end

  def children_name
    children.map(&:name)
  end

  def properties_name
    properties.map(&:name)
  end

  # def save_property_values(property_ids)
  def save_related_properties(property_ids)
    new_properties =  if property_ids.blank?
                    []
                  else
                    Sys::Property.account_properties.where(id: property_ids)
                  end
    self.properties = new_properties

    current_pro_ids = property_ids.collect{|s| s.to_i}.select{|i| i > 0}
    old_pro_ids = self.category_properties.map(&:property_id)

    (current_pro_ids - old_pro_ids).each do |property_id|
      Sys::CategoryProperty.create(account_id: self.account_id, category_id: self.id, property_id: property_id, updater_id: User.current_id)
    end

    deleted_ids = (old_pro_ids - current_pro_ids)
    Sys::CategoryProperty.destroy_all(category_id: self.id, property_id: deleted_ids) if deleted_ids.present?
  end
end
