# encoding : utf-8 -*-
# create_table "tb_app_tokens", force: true do |t|
#     t.integer  "shop_id"
#     t.string   "user_id",       limit: 20, default: ""
#     t.string   "nick",          limit: 30
#     t.string   "access_token"
#     t.string   "token_type",    limit: 30
#     t.integer  "expires_in"
#     t.string   "refresh_token"
#     t.integer  "re_expires_in"
#     t.integer  "r1_expires_in"
#     t.integer  "r2_expires_in"
#     t.integer  "w1_expires_in"
#     t.integer  "w2_expires_in"
#     t.integer  "sub_user_id"
#     t.string   "sub_nick",      limit: 30
#     t.datetime "created_at"
#     t.datetime "updated_at"
#   end
#   add_index "tb_app_tokens", ["shop_id"], name: "idx_by_shop_id", using: :btree
class Tb::AppToken < ActiveRecord::Base
  belongs_to  :shop
end
