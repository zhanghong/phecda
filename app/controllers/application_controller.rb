class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  #before_filter :authenticate_user!
  protect_from_forgery with: :exception
  # before_filter :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?
  # before_filter :set_current_user
  # layout :layout_by_resource
  # authorize_resource :unless => :is_skip_controller?

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name << :mobile
    devise_parameter_sanitizer.for(:account_update) << :name << :mobile
  end

  def is_skip_controller?
    if devise_controller?
      true
    else
      %w(
         oauths
         ).include?(params[:controller])
    end
  end

  def set_current_user
    User.current = current_user
  end

  def layout_by_resource
    "application"
    # if devise_controller? && params[:controller] != "registrations"
    #   "login"
    # else
    #   "application"
    # end
  end
end
