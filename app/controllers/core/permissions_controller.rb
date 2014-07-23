class Core::PermissionsController < ApplicationController
  before_action :set_core_permission, only: [:show, :edit, :update, :destroy]

  # GET /core/permissions
  # GET /core/permissions.json
  def index
    @core_permissions = Core::Permission.find_mine(params).paginate(page: params[:page])
  end

  # GET /core/permissions/1
  # GET /core/permissions/1.json
  def show
  end

  # GET /core/permissions/new
  def new
    @core_permission = Core::Permission.new
  end

  # GET /core/permissions/1/edit
  def edit
  end

  # POST /core/permissions
  # POST /core/permissions.json
  def create
    @core_permission = Core::Permission.new(core_permission_params)

    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to(action: "index")}
        format.json { head :no_content}
      elsif @core_permission.save
        format.html { redirect_to @core_permission, notice: 'Permission was successfully created.' }
        format.json { render action: 'show', status: :created, location: @core_permission }
      else
        format.html { render action: 'new' }
        format.json { render json: @core_permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /core/permissions/1
  # PATCH/PUT /core/permissions/1.json
  def update
    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to @core_permission}
        format.json { head :no_content }
      elsif @core_permission.update(core_permission_params)
        format.html { redirect_to @core_permission, notice: 'Permission was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @core_permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /core/permissions/1
  # DELETE /core/permissions/1.json
  def destroy
    @core_permission.destroy
    respond_to do |format|
      format.html { redirect_to core_permissions_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_core_permission
    @core_permission = Core::Permission.find_by_id(params[:id])
    redirect_to(action: "index") and redirect_to if @core_permission.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def core_permission_params
    params.require(:core_permission).permit(:module_name, :group_name, :name, :subject_class, :action, :ability_method, :sort_num).merge({updater_id: current_user.id})
  end
end
