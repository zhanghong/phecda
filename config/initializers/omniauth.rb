# -*- encoding : utf-8 -*-
require 'omniauth/strategies/taobao'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :taobao, Settings.tb_app_key, Settings.tb_secret_key, {:provider_ignores_state => true}
end