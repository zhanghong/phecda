# encoding : utf-8 -*-
# create_table "shops", force: true do |t|
#   t.string   "cid",            limit: 50,  default: ""
#   t.string   "nick",           limit: 100, default: ""
#   t.string   "title",          limit: 100, default: ""
#   t.string   "desc",                       default: ""
#   t.string   "bulletin",                   default: ""
#   t.string   "pic_path",                   default: ""
#   t.datetime "tb_created_at"
#   t.datetime "tb_modified_at"
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.string   "sid",            limit: 20,  default: ""
#   t.string   "type",           limit: 30,  default: ""
# end
class Shop < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: "users_shops", foreign_key: "shop_id"

  after_save  :add_to_superadmin

  def self.current=(shop)
    Thread.current[:current_shop] = shop
  end

  def self.current
    Thread.current[:current_shop]
  end

private
  def add_to_superadmin
    User.add_shop_to_superadmins(self)
  end
end
