#class OauthsController < Devise::OmniauthCallbacksController
class OauthsController < ApplicationController
  skip_before_filter  :authorize_resource

	def taobao
    if auth_hash
      Tb::Shop.create_by_omniauth(auth_hash)
    else
      Tb::Shop.create_by_authorization_code(params[:code])
    end
		render text: "hello callback"
	end
protected
  def auth_hash
    request.env['omniauth.auth']
  end
end
