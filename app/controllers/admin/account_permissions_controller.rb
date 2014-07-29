# encoding : utf-8 -*-
class Admin::AccountPermissionsController < ApplicationController
  before_action :set_admin_account_permission, only: [:show, :edit, :update, :destroy]
  before_action :set_account, only: [:edit_permissions, :update_permissions]
  authorize_resource  :class => Admin::Permission

  # GET /admin/account_permissions
  # GET /admin/account_permissions.json
  def index
    @admin_account_permissions = Admin::AccountPermission.account_group_find(params).paginate(page: params[:page])
  end

  # GET /admin/account_permissions/1
  # GET /admin/account_permissions/1.json
  def show
  end

  # GET /admin/account_permissions/new
  def new
    @admin_account_permission = Admin::AccountPermission.new
  end

  # GET /admin/account_permissions/1/edit
  def edit
  end

  # POST /admin/account_permissions
  # POST /admin/account_permissions.json
  def create
    @admin_account_permission = Admin::AccountPermission.new(admin_account_permission_params)

    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to(action: "index")}
        format.json { head :no_content}
      elsif @admin_account_permission.save
        format.html { redirect_to @admin_account_permission, notice: 'Account permission was successfully created.' }
        format.json { render action: 'show', status: :created, location: @admin_account_permission }
      else
        format.html { render action: 'new' }
        format.json { render json: @admin_account_permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/account_permissions/1
  # PATCH/PUT /admin/account_permissions/1.json
  def update
    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to @admin_account_permission}
        format.json { head :no_content }
      elsif @admin_account_permission.update(admin_account_permission_params)
        format.html { redirect_to @admin_account_permission, notice: 'Account permission was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @admin_account_permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/account_permissions/1
  # DELETE /admin/account_permissions/1.json
  def destroy
    @admin_account_permission.destroy
    respond_to do |format|
      format.html { redirect_to admin_account_permissions_url }
      format.json { head :no_content }
    end
  end

  def edit_permissions
    @account_permission_ids = @account.account_permissions.map(&:permission_id)
    @permissions = Admin::Permission.order(:sort_num).all
  end

  def update_permissions
    @account_permission_ids = @account.account_permissions.map(&:permission_id)
    @permissions = Admin::Permission.order(:sort_num).all

    if params[:btn_cancel].present?
      #do nothing
    elsif params[:permission_ids].is_a?(Array)
      owned_pmt_ids = @account.account_permissions.map(&:permission_id)
      current_pmt_ids = params[:permission_ids].collect{|pid| pid.to_i}
      (current_pmt_ids - owned_pmt_ids).each do |pmt_id|
        Admin::AccountPermission.create(account_id: @account.id, permission_id: pmt_id, updater_id: current_user.id)
      end
      
      delete_pmt_ids = (owned_pmt_ids - current_pmt_ids)
      Admin::AccountPermission.destroy_all(account_id: @account.id, permission_id: delete_pmt_ids) if delete_pmt_ids.present?
      flash[:notice] = "更新成功"
    else
      Admin::AccountPermission.destroy_all(account_id: @account.id)
      flash[:notice] = "更新成功"
    end

    respond_to do |format|
      format.html { redirect_to edit_permissions_admin_account_permissions_path(account_id: @account.id)}
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_admin_account_permission
    @admin_account_permission = Admin::AccountPermission.find_by_id(params[:id])
    redirect_to(action: "index") and return if @admin_account_permission.nil?
  end

  def set_account
    @account = Account.find_by_id(params[:account_id])
    #redirect_to(action: "index") and return if @account.nil?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_account_permission_params
    params.require(:admin_account_permission).permit(:account_id)
  end
end
