# encoding : utf-8 -*-
# create_table "users", force: true do |t|
#   t.string   "name",                   limit: 20, default: "", null: false
#   t.string   "mobile",                 limit: 13, default: "", null: false
#   t.string   "email",                  limit: 40, default: "", null: false
#   t.string   "encrypted_password",                default: "", null: false
#   t.string   "role",                   limit: 15, default: "", null: false
#   t.string   "reset_password_token"
#   t.datetime "reset_password_sent_at"
#   t.datetime "remember_created_at"
#   t.integer  "sign_in_count",                     default: 0,  null: false
#   t.datetime "current_sign_in_at"
#   t.datetime "last_sign_in_at"
#   t.string   "current_sign_in_ip"
#   t.string   "last_sign_in_ip"
#   t.string   "confirmation_token"
#   t.datetime "confirmed_at"
#   t.datetime "confirmation_sent_at"
#   t.string   "unconfirmed_email"
#   t.integer  "failed_attempts",                   default: 0,  null: false
#   t.string   "unlock_token"
#   t.datetime "locked_at"
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
# add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
# add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :name,
            :presence => true,
            :uniqueness => true,
            :length => {:within => 3..16}

  ROLES = %w[super_admin admin]
end
