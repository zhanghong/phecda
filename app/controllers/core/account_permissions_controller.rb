class Core::AccountPermissionsController < ApplicationController
  before_action :set_core_account_permission, only: [:show, :edit, :update, :destroy]

  # GET /core/account_permissions
  # GET /core/account_permissions.json
  def index
    @core_account_permissions = Core::AccountPermission.find_mine(params).paginate(page: params[:page])
  end

  # GET /core/account_permissions/1
  # GET /core/account_permissions/1.json
  def show
  end

  # GET /core/account_permissions/new
  def new
    @core_account_permission = Core::AccountPermission.new
  end

  # GET /core/account_permissions/1/edit
  def edit
  end

  # POST /core/account_permissions
  # POST /core/account_permissions.json
  def create
    @core_account_permission = Core::AccountPermission.new(core_account_permission_params)

    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to(action: "index")}
        format.json { head :no_content}
      elsif @core_account_permission.save
        format.html { redirect_to @core_account_permission, notice: 'Account permission was successfully created.' }
        format.json { render action: 'show', status: :created, location: @core_account_permission }
      else
        format.html { render action: 'new' }
        format.json { render json: @core_account_permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /core/account_permissions/1
  # PATCH/PUT /core/account_permissions/1.json
  def update
    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to(core_account_permission)}
        format.json { head :no_content}
      elsif @core_account_permission.update(core_account_permission_params)
        format.html { redirect_to @core_account_permission, notice: 'Account permission was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @core_account_permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /core/account_permissions/1
  # DELETE /core/account_permissions/1.json
  def destroy
    @core_account_permission.destroy
    respond_to do |format|
      format.html { redirect_to core_account_permissions_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_core_account_permission
    @core_account_permission = Core::AccountPermission.find_by_id(params[:id])
    redirect_to(action: "index") and redirect_to if @core_account_permission.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def core_account_permission_params
    params.require(:core_account_permission).permit(:permission_id).merge({account_id: current_account.id, updater_id: current_user.id})
  end
end
