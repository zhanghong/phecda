# encoding : utf-8 -*-
# create_table "sys_categories", force: true do |t|
#   t.string   "name",              limit: 30, default: ""
#   t.integer  "account_id",                   default: 0
#   t.string   "status",            limit: 20, default: ""
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
#   t.integer  "user_id",                      default: 0
# end
class Sys::Category < ActiveRecord::Base
  scope :account_scope, -> {where(account_id: Account.current.id)}
  scope :actived, -> {where(deleted_at: nil)}

  has_and_belongs_to_many :properties, join_table: "sys_categories_properties", class_name: "Sys::Property"
  belongs_to  :account
  belongs_to  :updater, class_name: "User"
  belongs_to  :deleter, class_name: "User"

  acts_as_nested_set :counter_cache => :children_count

  STATUS = [["启用", "actived"], ["隐藏", "hidden"]]

  def self.find_mine(params)
    conditions = [[]]

    [:name].each do |attr|
      next if params[attr].blank?
      conditions[0] << "#{attr} LIKE ?"
      conditions << "%#{params[attr]}%"
    end

    [:parent_id, :status].each do |attr|
      next if params[attr].blank?
      conditions[0] << "#{attr} = ?"
      conditions << params[attr]
    end

    conditions[0] = conditions[0].join(" AND ")
    account_scope.actived.where(conditions)
  end

  def self.sync_to_taobao
    self.all.each do |category|
      category.sync_to_taobao
    end
  end

  def self.list_shown_attributes
    %w(name status_name parent_name created_at updated_at)
  end

  def self.detail_shown_attributes
    %w(name status_name created_at updated_at parent_name children_name properties_name)
  end

  def self.account_roots
    account_scope.actived.roots
  end

  def sync_to_taobao
    response = TaobaoFu.get(method: 'taobao.sellercats.list.add',
                   name: self.name,
                   pict_url: self.pic_url,
                   parent_cid: self.parent_id
               )
    puts response.class
    p response
    seller_cat = response["sellercats_list_add_response"]["seller_cat"] rescue {}
    if seller_cat.present?
      self.update(taobao_id: seller_cat["cid"], taobao_updated_at: seller_cat["created"])
    end
  end

  def status_name
    status_item = STATUS.find{|s| s.last == self.status}
    if status_item
      status_item.first
    else
      self.status
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

  def save_property_values(property_ids)
    new_properties =  if property_ids.blank?
                    []
                  else
                    Sys::Property.account_properties.where(id: property_ids)
                  end
    self.properties = new_properties
  end

  def updater_name
    updater.name
  end

  def destroy
    self.properties = []
    update_attributes(deleted_at: Time.now, deleter_id: User.current_id)
  end
end
