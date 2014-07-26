# encoding : utf-8 -*-
# create_table "accounts", force: true do |t|
#   t.string   "name",       limit: 30, default: ""
#   t.string   "phone",      limit: 13, default: ""
#   t.string   "email",      limit: 50, default: ""
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
class Account < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: "users_accounts"#, foreign_key: "account_id"
  has_many  :shops, dependent: :destroy
  has_many  :sellers, dependent: :destroy

  def self.current=(account)
    Thread.current[:current_account] = account
  end

  def self.current
    Thread.current[:current_account]
  end

  def self.current_id
    if self.current.nil?
      -1
    else
      self.current.id
    end
  end
private
  def add_to_superadmin
    User.add_shop_to_superadmins(self)
  end
end
