# encoding : utf-8 -*-
require 'crack/json'
require 'oauth2'
module Tb::Query

  def self.get(options, shop_id = nil)
  	if app_token = Tb::AppToken.where(shop_id: shop_id).first
      oauth_https_get(options, app_token)
    else
      TaobaoFu.select_app_session(shop_id)
      TaobaoFu.get(options)
  	end
  end

  def self.oauth_https_get(options, shop_id = nil)
  	if shop_app = Tb::AppToken.where(shop_id: shop_id).first
  		sorted_params = {
        access_token: shop_app.access_token,
        format:      'json',
        v:           '2.0',
        timestamp:   Time.now.strftime("%Y-%m-%d %H:%M:%S")
      }.merge!(options)

      response = Excon.get(Settings.tb_base_url, :query => sorted_params)
      JSON.parse(response.body, :quirks_mode => true)
  	end
  end

  # 获取taobao shop 免签信息
  def self.get_oauth_token(shop_code)
  	sorted_params = {
  		code: shop_code,
  		grant_type: "authorization_code",
  		client_id: Settings.tb_app_key,
  		client_secret: Settings.tb_secret_key,
  		redirect_uri: "http://erp.zhanghong.com/auth/taobao/callback"
  	}

    response = Excon.post(Settings.tb_token_url, :query => sorted_params)
    JSON.parse(response.body, :quirks_mode => true)
  end

  # 生成淘宝沙箱授权url
  def self.build_sandbox_aouth_url
    if Settings.tb_is_sandbox
      stored_parems = {
        response_type: "code",
        client_id: Settings.tb_app_key,
        redirect_uri: "http://erp.henry.com/oauths/tb_callback",
        from_site: "fuwu"
      }
      params_array = stored_parems.sort_by { |k,v| k.to_s }
      total_param = params_array.map { |key, value| key.to_s+"="+value.to_s }
      generate_query_string = URI.escape(total_param.join("&"))
      puts "https://oauth.tbsandbox.com/authorize?" + generate_query_string
    end
  end

  # 打印请求地址
  def self.print_request_url(params, base_url = Settings.tb_base_url)
    total_param = params.map { |key, value| key.to_s+"="+value.to_s }
    generate_query_string = URI.escape(total_param.join("&"))
    puts base_url + "?" + generate_query_string
  end
end

