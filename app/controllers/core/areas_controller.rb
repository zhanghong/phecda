class Core::AreasController < ApplicationController
  before_action :set_core_area, only: [:show, :edit, :update, :destroy]
  authorize_resource  :class => Core::Area

  # GET /core/areas
  # GET /core/areas.json
  def index
    @core_areas = Core::Area.find_mine(params).paginate(page: params[:page])

    respond_to do |format|
      format.html {}
      format.json {}
    end
  end

  # GET /core/areas/1
  # GET /core/areas/1.json
  def show
    @core_seller_areas = Core::SellerArea.find_mine(area_id: @core_area.id).paginate(page: params[:page])
    @core_logistic_areas = Core::LogisticArea.find_mine(area_id: @core_area.id).paginate(page: params[:page])
  end

  # GET /core/areas/new
  def new
    @core_area = Core::Area.new
  end

  # GET /core/areas/1/edit
  def edit
  end

  # POST /core/areas
  # POST /core/areas.json
  def create
    @core_area = Core::Area.new(core_area_params)

    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to(action: "index")}
        format.json { head :no_content}
      elsif @core_area.save
        format.html { redirect_to @core_area, notice: 'Area was successfully created.' }
        format.json { render action: 'show', status: :created, location: @core_area }
      else
        format.html { render action: 'new' }
        format.json { render json: @core_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /core/areas/1
  # PATCH/PUT /core/areas/1.json
  def update
    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to @core_area}
        format.json { head :no_content }
      elsif @core_area.update(core_area_params)
        format.html { redirect_to @core_area, notice: 'Area was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @core_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /core/areas/1
  # DELETE /core/areas/1.json
  def destroy
    @core_area.destroy
    respond_to do |format|
      format.html { redirect_to core_areas_url }
      format.json { head :no_content }
    end
  end

private
# Use callbacks to share common setup or constraints between actions.
def set_core_area
  @core_area = Core::Area.find_by_id(params[:id])
  redirect_to(action: "index") and redirect_to if @core_area.blank?
end

# Never trust parameters from the scary internet, only allow the white list through.
def core_area_params
  params.require(:core_area).permit(:name, :parent_id).merge({updater_id: current_user.id})
end
end
