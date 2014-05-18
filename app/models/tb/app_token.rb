# encoding : utf-8 -*-
# create_table "tb_app_tokens", force: true do |t|
#   t.integer  "shop_id"
#   t.string   "user_id",       limit: 20, default: ""
#   t.string   "nick",          limit: 30
#   t.string   "access_token"
#   t.string   "token_type",    limit: 30
#   t.integer  "expires_in"
#   t.string   "refresh_token"
#   t.integer  "re_expires_in"
#   t.integer  "r1_expires_in"
#   t.integer  "r2_expires_in"
#   t.integer  "w1_expires_in"
#   t.integer  "w2_expires_in"
#   t.integer  "sub_user_id"
#   t.string   "sub_nick",      limit: 30
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.datetime "expires_at"
#   t.boolean  "expires"
#   t.integer  "app_id"
#   t.string   "auth_type",     limit: 10, default: ""
#   t.datetime "refreshed_at"
# end
# add_index "tb_app_tokens", ["shop_id"], name: "idx_by_shop_id", using: :btree
class Tb::AppToken < ActiveRecord::Base
  belongs_to  :shop,  class_name: "Tb::Shop",   foreign_key: "shop_id"
  belongs_to  :app,   class_name: "Tb::App",    foreign_key: "app_id"

  def check_or_refresh!
    if can_refresh?
      params = {
                client_id: app.key_id,
                client_secret: app.secret,
                grant_type: 'refresh_token',
                refresh_token: refresh_token
              }
      response = Excon.post(Settings.tb_token_url, :query => params)
      app_token = JSON.parse(response.body, :quirks_mode => true)
      mappings = {"taobao_user_id" => "user_id", "taobao_user_nick" => "nick"}
      app_token.keys.each do |k|
        app_token[mappings[k]] = app_token.delete(k) if mappings[k]
      end
      app_token[:refreshed_at] = Time.now
      update(app_token)
    end
  end

private
  def can_refresh?
    true
  end
end
