#class OauthsController < Devise::OmniauthCallbacksController
class OauthsController < ApplicationController
	def taobao
    Tb::Shop.create_by_oauth(auth_hash)
		render text: "hello callback"
	end
protected
  def auth_hash
    request.env['omniauth.auth']
  end
end
