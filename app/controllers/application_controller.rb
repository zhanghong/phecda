class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery with: :exception
  before_filter :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_current_user
  before_filter :current_account
  layout :layout_by_resource
  authorize_resource :unless => :is_skip_controller?

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:name)}
    devise_parameter_sanitizer.for(:account_update) << :name << :mobile
  end

  def is_skip_controller?
    if devise_controller?
      true
    else
      %w(
         oauths
         home
         edm/tasks
         ).include?(params[:controller])
    end
  end

  def set_current_user
    User.current = current_user
  end

  def current_account
    @current_account ||= (session[:account_id] && Account.find(session[:account_id])) || (current_user && current_user.accounts.first)
    Account.current = @current_account
  end

  def layout_by_resource
    if devise_controller? && params[:controller] != "registrations"
      "login"
    elsif "edm/tasks"
      nil
    else
      "application"
    end
  end

  def find_core_stock
    @core_stock = Core::Stock.find_by_id(params[:stock_id])
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to("/", :alert => exception.message)
  end
end
