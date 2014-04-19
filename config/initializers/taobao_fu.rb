require 'taobao_fu'

require 'yaml'
YAML::ENGINE.yamler = 'syck'

# config_file = File.join(Rails.root, "config", "taobao.yml")
# TaobaoFu.load(config_file) if FileTest::exists?(config_file)

select_app_session_function = %q{
  def self.select_app_session(shop_id)
    app_session = Tb::AppSession.where(shop_id: shop_id).first

    if app_session
      settings = {}
      settings["app_key"] = app_session.app_key
      settings["secret_key"] = app_session.app_secret
      settings["session"] = app_session.session_key
      settings["is_sandbox"] = Settings.tb_is_sandbox
      settings["use_curl"] = Settings.tb_use_curl
      TaobaoFu.settings = settings
    end
  end
}

TaobaoFu.module_eval(select_app_session_function)
