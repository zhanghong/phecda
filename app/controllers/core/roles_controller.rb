class Core::RolesController < ApplicationController
  before_action :set_core_role, only: [:show, :edit, :update, :destroy]

  # GET /core/roles
  # GET /core/roles.json
  def index
    @core_roles = Core::Role.find_mine(params).paginate(page: params[:page])
  end

  # GET /core/roles/1
  # GET /core/roles/1.json
  def show
    find_permissions
    @role_permission_ids = @core_role.role_permissions.map(&:permission_id)
  end

  # GET /core/roles/new
  def new
    @core_role = Core::Role.new
    find_permissions
    @role_permission_ids = []
  end

  # GET /core/roles/1/edit
  def edit
    find_permissions
    @role_permission_ids = @core_role.role_permissions.map(&:permission_id)
  end

  # POST /core/roles
  # POST /core/roles.json
  def create
    @core_role = Core::Role.new(core_role_params)

    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to(action: "index")}
        format.json { head :no_content}
      elsif @core_role.save
        format.html { redirect_to @core_role, notice: 'Role was successfully created.' }
        format.json { render action: 'show', status: :created, location: @core_role }
      else
        find_permissions
        format.html { render action: 'new' }
        format.json { render json: @core_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /core/roles/1
  # PATCH/PUT /core/roles/1.json
  def update
    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to @core_role}
        format.json { head :no_content }
      elsif @core_role.update(core_role_params)
        format.html { redirect_to @core_role, notice: 'Role was successfully updated.' }
        format.json { head :no_content }
      else
        find_permissions
        format.html { render action: 'edit' }
        format.json { render json: @core_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /core/roles/1
  # DELETE /core/roles/1.json
  def destroy
    @core_role.destroy
    respond_to do |format|
      format.html { redirect_to core_roles_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_core_role
    @core_role = Core::Role.find_by_id(params[:id])
    redirect_to(action: "index") and redirect_to if @core_role.blank?
  end

  def find_permissions
    @permissions = Admin::Permission.account_all_permissions(@core_role.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def core_role_params
    if params[:permission_ids].is_a?(Array)
      @role_permission_ids = params[:permission_ids].collect{|p| p.to_i}
    else
      @role_permission_ids = []
    end
    params.require(:core_role).permit(:name).merge({account_id: current_account.id, updater_id: current_user.id, permisson_ids: @role_permission_ids})
  end
end
