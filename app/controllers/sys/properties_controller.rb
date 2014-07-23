class Sys::PropertiesController < ApplicationController
  before_action :set_sys_property, only: [:show, :edit, :update, :destroy]

  # GET /sys/properties
  # GET /sys/properties.json
  def index
    @sys_properties = Sys::Property.find_mine(params).paginate(page: params[:page])
  end

  # GET /sys/properties/1
  # GET /sys/properties/1.json
  def show
  end

  # GET /sys/properties/new
  def new
    @sys_property = Sys::Property.new
  end

  # GET /sys/properties/1/edit
  def edit
  end

  # POST /sys/properties
  # POST /sys/properties.json
  def create
    @sys_property = Sys::Property.new(sys_property_params)

    respond_to do |format|
      if @sys_property.save
        format.html { redirect_to @sys_property, notice: 'Property was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sys_property }
      else
        format.html { render action: 'new' }
        format.json { render json: @sys_property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sys/properties/1
  # PATCH/PUT /sys/properties/1.json
  def update
    respond_to do |format|
      if @sys_property.update(sys_property_params)
        @sys_property.save_property_values(params[:property_values_name])
        format.html { redirect_to @sys_property, notice: 'Property was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sys_property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sys/properties/1
  # DELETE /sys/properties/1.json
  def destroy
    @sys_property.destroy
    respond_to do |format|
      format.html { redirect_to sys_properties_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_sys_property
    @sys_property = Sys::Property.account_scope.find_by_id(params[:id])
    redirect_to(action: "index") and return if @sys_property.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sys_property_params
    params.require(:sys_property).permit(:name, :status, :values_name).merge({account_id: current_account.id, updater_id: current_user.id})
  end
end
