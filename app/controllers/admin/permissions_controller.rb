class Admin::PermissionsController < ApplicationController
  before_action :set_admin_permission, only: [:show, :edit, :update, :destroy]

  # GET /admin/permissions
  # GET /admin/permissions.json
  def index
    @admin_permissions = Admin::Permission.find_mine(params).paginate(page: params[:page])
  end

  # GET /admin/permissions/1
  # GET /admin/permissions/1.json
  def show
    @admin_account_permissions = @admin_permission.account_permissions
  end

  # GET /admin/permissions/new
  def new
    @admin_permission = Admin::Permission.new
  end

  # GET /admin/permissions/1/edit
  def edit
  end

  # POST /admin/permissions
  # POST /admin/permissions.json
  def create
    @admin_permission = Admin::Permission.new(admin_permission_params)

    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to(action: "index")}
        format.json { head :no_content}
      elsif @admin_permission.save
        format.html { redirect_to @admin_permission, notice: 'Permission was successfully created.' }
        format.json { render action: 'show', status: :created, location: @admin_permission }
      else
        format.html { render action: 'new' }
        format.json { render json: @admin_permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/permissions/1
  # PATCH/PUT /admin/permissions/1.json
  def update
    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to @admin_permission}
        format.json { head :no_content }
      elsif @admin_permission.update(admin_permission_params)
        format.html { redirect_to @admin_permission, notice: 'Permission was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @admin_permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/permissions/1
  # DELETE /admin/permissions/1.json
  def destroy
    @admin_permission.destroy
    respond_to do |format|
      format.html { redirect_to admin_permissions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_permission
      @admin_permission = Admin::Permission.find_by_id(params[:id])
      redirect_to(action: "index") and redirect_to if @admin_permission.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_permission_params
      params.require(:admin_permission).permit(:module_name, :group_name, :name, :subject_class, :action, :ability_method, :sort_num).merge({updater_id: current_user.id})
    end
end
