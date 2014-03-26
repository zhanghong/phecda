# encoding : utf-8 -*-
require 'crack/json'
require 'oauth2'
module Tb::Query

  def self.get(options, shop_id = nil)
  	if app_token = Tb::AppToken.where(shop_id: shop_id).first
      puts "11111..........."
      # oauth_token_https_get(options, app_token)
      oauth_https_get(options, app_token)
    else
      TaobaoFu.select_app_session(shop_id)
      TaobaoFu.get(options)
  	end
  end

  def self.oauth_token_https_get(options, app_token)
    base_url = Settings.tb_base_url
    sorted_params = {
      access_token: app_token.access_token,
      format:      'json',
      v:           '2.0',
      timestamp:   Time.now.strftime("%Y-%m-%d %H:%M:%S")
    }.merge!(options)

    params_array = sorted_params.sort_by { |k,v| k.to_s }
    total_param = params_array.map { |key, value| key.to_s+"="+value.to_s }
    generate_query_string = URI.escape(total_param.join("&"))
    data = HTTParty.get(base_url + generate_query_string).parsed_response.to_json #Hash2JSON
    response = JSON.parse(data, :quirks_mode => true)
    JSON.parse(response)
  end

  def self.oauth_https_get(options, shop_id = nil)
  	if shop_app = Tb::AppToken.where(shop_id: shop_id).first
  		base_url = Settings.tb_base_url

  		sorted_params = {
        access_token: shop_app.access_token,
        format:      'json',
        v:           '2.0',
        timestamp:   Time.now.strftime("%Y-%m-%d %H:%M:%S")
      }.merge!(options)

      params_array = sorted_params.sort_by { |k,v| k.to_s }
      total_param = params_array.map { |key, value| key.to_s+"="+value.to_s }
      generate_query_string = URI.escape(total_param.join("&"))
      data = HTTParty.get(base_url + generate_query_string).parsed_response.to_json #Hash2JSON
      # puts "data........ " * 8
      # puts data
      # p ActiveSupport::JSON.decode(data)
      # puts "data........ " * 8
      # response = ActiveSupport::JSON.decode(data)
      response = JSON.parse(data, :quirks_mode => true)
      JSON.parse(response)
      # response = Crack::JSON.parse(data)
  	end
  end

  # 获取taobao shop 免签信息
  def self.get_oauth_token(shop_code)
  	base_url = Settings.tb_token_url
  	sorted_params = {
  		code: shop_code,
  		grant_type: "authorization_code",
  		client_id: Settings.tb_app_key,
  		client_secret: Settings.tb_secret_key,
  		redirect_uri: Settings.tb_callback_url
  	}

  	params_array = sorted_params.sort_by { |k,v| k.to_s }
    total_param = params_array.map { |key, value| key.to_s+"="+value.to_s }
    generate_query_string = URI.escape(total_param.join("&"))
    data = HTTParty.post(base_url + generate_query_string).parsed_response.to_json #Hash2JSON
    response = Crack::JSON.parse(data)
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
end

