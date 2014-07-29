class Core::LogisticAreasController < ApplicationController
  before_action :set_core_logistic_area, only: [:show, :edit, :update, :destroy]
  before_action :find_from_objects,  only: [:new, :edit]
  authorize_resource  :class => Core::LogisticArea

  # # GET /core/logistic_areas
  # # GET /core/logistic_areas.json
  def index
    @core_logistic_areas = Core::LogisticArea.find_mine(params).paginate(page: params[:page])
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  # # GET /core/logistic_areas/1
  # # GET /core/logistic_areas/1.json
  # def show
  # end

  # GET /core/logistic_areas/new
  def new
    attrs = {}
    [:area_id, :logistic_id].each do |name|
      attrs[name] = params[name] if params[name].present?
    end
    @core_logistic_area = Core::LogisticArea.new(attrs)
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  # # GET /core/logistic_areas/1/edit
  # def edit
  # end

  # POST /core/logistic_areas
  # POST /core/logistic_areas.json
  def create
    @core_logistic_area = Core::LogisticArea.new(core_logistic_area_params)

    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to(action: "index")}
        format.json { head :no_content}
        format.js {}
      elsif @core_logistic_area.save
        format.html { redirect_to @core_logistic_area, notice: 'Logistic area was successfully created.' }
        format.json { render action: 'show', status: :created, location: @core_logistic_area }
        format.js { find_relates_by_from }
      else
        find_from_objects
        format.html { render action: 'new' }
        format.json { render json: @core_logistic_area.errors, status: :unprocessable_entity }
        format.js do 
          find_from_objects
          render action: 'new'
        end
      end
    end
  end

  # # PATCH/PUT /core/logistic_areas/1
  # # PATCH/PUT /core/logistic_areas/1.json
  # def update
  #   respond_to do |format|
  #     if params[:btn_cancel].present?
  #       format.html { redirect_to @core_logistic_area}
  #       format.json { head :no_content }
  #       format.js {}
  #     elsif @core_logistic_area.update(core_logistic_area_params)
  #       format.html { redirect_to @core_logistic_area, notice: 'Logistic area was successfully updated.' }
  #       format.json { head :no_content }
  #       format.js { find_relates_by_from }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @core_logistic_area.errors, status: :unprocessable_entity }
  #       format.js do 
  #         find_from_objects
  #         render action: 'edit'
  #       end
  #     end
  #   end
  # end

  # DELETE /core/logistic_areas/1
  # DELETE /core/logistic_areas/1.json
  def destroy
    @core_logistic_area.destroy
    respond_to do |format|
      format.html { redirect_to sku_bindings_url }
      format.json { head :no_content }
      format.js do
        find_relates_by_from
      end
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_core_logistic_area
    @core_logistic_area = Core::LogisticArea.find_by_id(params[:id])
    redirect_to(action: "index") and redirect_to if @core_logistic_area.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def core_logistic_area_params
    params.require(:core_logistic_area).permit(:logistic_id, :area_id).merge({account_id: current_account.id, updater_id: current_user.id})
  end

  def find_from_objects
    case params[:from]
    when "area"
      @core_logistics = Core::Logistic.all
    when "logistic"
      @core_areas = Core::Area.roots
    end
  end

  def find_relates_by_from
    conditions =  case params[:from]
                  when "logistic"
                    {logistic_id: @core_logistic_area.logistic_id}
                  when "area"
                    {area_id: @core_logistic_area.area_id}
                  else
                    {id: 0}
                  end
    @core_logistic_areas = Core::LogisticArea.find_mine(conditions).paginate(page: params[:page])
  end
end
