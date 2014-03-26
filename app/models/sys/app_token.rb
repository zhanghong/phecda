# encoding : utf-8 -*-
class Sys::AppToken < ActiveRecord::Base
	establish_connection "solo_#{Rails.env}"
  self.table_name = "taobao_app_tokens"

  def self.sync_to_new_db
    app_id = 2
    self.all.each do |app|
      shop = Tb::Shop.find_or_create_by(nick: app.taobao_user_nick, app_id: app_id)
      app_token = Tb::AppToken.find_or_create_by(shop_id: shop.id)
      app_token.update(
        user_id: app.taobao_user_id,
        nick: app.taobao_user_nick,
        access_token: app.access_token,
        token_type: "Bearer",
        refresh_token: app.refresh_token
                       )
    end
  end
end
