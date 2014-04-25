# encoding : utf-8 -*-
# create_table "tb_shops", force: true do |t|
#   t.integer  "account_id",     limit: 8,   default: 0
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
#   t.string   "user_id",        limit: 20,  default: ""
#   t.string   "sid",            limit: 20,  default: ""
# end
class Tb::Shop < ActiveRecord::Base
  belongs_to  :account
  has_many    :app_tokens, class_name: "Tb::AppToken",  foreign_key: "shop_id", dependent: :destroy
  has_many    :categories,  class_name: "Tb::Category",   foreign_key: "shop_id", dependent: :destroy
  has_many    :products,  class_name: "Tb::Product",   foreign_key: "shop_id", dependent: :destroy
  has_many    :skus,  class_name: "Tb::Product",   foreign_key: "shop_id", dependent: :destroy
  has_many    :properties,  class_name: "Tb::Property",   foreign_key: "shop_id", dependent: :destroy
  has_many    :property_values,  class_name: "Tb::PropertyValue",   foreign_key: "shop_id", dependent: :destroy

  # no rspec test
  def self.create_by_omniauth(auth_hash)
    token_info = auth_hash["credentials"].merge(auth_hash["extra"]["raw_info"])
    mappings = {"token" => "access_token", "taobao_user_id" => "user_id", "taobao_user_nick" => "nick"}
    token_info.keys.each do |k|
      token_info[mappings[k]] = token_info.delete(k) if mappings[k]
    end
    token_info["expires_at"] = Time.at(token_info["expires_at"].to_i)
    token_info["auth_type"] = "oauth2"

    shop = find_or_create_by(user_id: token_info["user_id"], nick: token_info["nick"])

    app_token = Tb::AppToken.find_or_create_by(shop_id: shop.id, app_id: 1)
    update_attrs = {}
    token_info.each do |k, v|
      update_attrs[k] = v
    end
    app_token.update(update_attrs)

    shop.pull_taobao_info
  end

  # 同步shop店铺信息
  def pull_taobao_info
  	response = Tb::Query.get({
					  		method: "taobao.shop.get",
					  		fields: "sid,cid,title,desc,bulletin,pic_path,created,modified",
					  		nick: nick
					  	}, id)
  	res_shop = response["shop_get_response"]["shop"]
    mappings = {"created" => "tb_created_at", "modified" => "tb_modified_at"}
    res_shop.keys.each do |k|
      res_shop[k] = CGI.unescape(res_shop[k]) if res_shop[k].is_a?(String)
      res_shop[mappings[k]] = res_shop.delete(k) if mappings[k]
    end
  	self.update(res_shop)
    self
  end

  # # shop免签授权
  # def self.create_by_authorization_code(code)
  #   res = Tb::Query.get_oauth_token(code)
  #   if res["error"]
  #     return false
  #   else
  #     nick = CGI.unescape(res["taobao_user_nick"])
  #     shop = find_or_initialize_by(nick: nick)
  #     shop.update({
  #       user_id: res["taobao_user_id"],
  #       auth_type: "oauth2"
  #       })
  #     shop.save_access_token(res)
  #     shop.pull_taobao_info
  #   end
  #   return true
  # end

  # # 保存shop的免签信息
  # def save_access_token(res)
  #   app_token = Tb::AppToken.find_or_create_by(shop_id: id)
  #   mappings = {"taobao_user_id" => "user_id", "taobao_user_nick" => "nick"}
  #   res.keys.each do |k|
  #     res[k] = CGI.unescape(res[k]) if res[k].is_a?(String)
  #     res[mappings[k]] = res.delete(k) if mappings[k]
  #   end
  #   app_token.update(res)
  # end
end
