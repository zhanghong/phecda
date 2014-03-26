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
# end
class Sys::Category < ActiveRecord::Base
  belongs_to  :account

  def self.sync_to_taobao
    self.all.each do |category|
      category.sync_to_taobao
    end
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
end
