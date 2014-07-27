class Core::UserRolesController < ApplicationController
  before_action :set_core_user_role, only: [:show, :edit, :update, :destroy]
  authorize_resource  :class => Core::UserRole

  # GET /core/user_roles
  # GET /core/user_roles.json
  def index
    @core_user_roles = Core::UserRole.find_mine(params).paginate(page: params[:page])
  end

  # GET /core/user_roles/1
  # GET /core/user_roles/1.json
  def show
  end

  # GET /core/user_roles/new
  def new
    @core_user_role = Core::UserRole.new
  end

  # GET /core/user_roles/1/edit
  def edit
  end

  # POST /core/user_roles
  # POST /core/user_roles.json
  def create
    @core_user_role = Core::UserRole.new(core_user_role_params)

    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to(action: "index")}
        format.json { head :no_content}
      elsif @core_user_role.save
        format.html { redirect_to @core_user_role, notice: 'User role was successfully created.' }
        format.json { render action: 'show', status: :created, location: @core_user_role }
      else
        format.html { render action: 'new' }
        format.json { render json: @core_user_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /core/user_roles/1
  # PATCH/PUT /core/user_roles/1.json
  def update
    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to @core_user_role}
        format.json { head :no_content }
      elsif @core_user_role.update(core_user_role_params)
        format.html { redirect_to @core_user_role, notice: 'User role was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @core_user_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /core/user_roles/1
  # DELETE /core/user_roles/1.json
  def destroy
    @core_user_role.destroy
    respond_to do |format|
      format.html { redirect_to core_user_roles_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_core_user_role
    @core_user_role = Core::UserRole.find_by_id(params[:id])
    redirect_to(action: "index") and redirect_to if @core_user_role.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def core_user_role_params
    params.require(:core_user_role).permit(:user_id, :role_id).merge({account_id: current_account.id, updater_id: current_user.id})
  end
end
