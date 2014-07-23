class Core::LogisticsController < ApplicationController
  before_action :set_core_logistic, only: [:show, :edit, :update, :destroy]

  # GET /core/logistics
  # GET /core/logistics.json
  def index
    @core_logistics = Core::Logistic.find_mine(params).paginate(page: params[:page])
  end

  # GET /core/logistics/1
  # GET /core/logistics/1.json
  def show
    @core_logistic_areas = Core::LogisticArea.find_mine(logistic_id: @core_logistic.id).paginate(page: params[:page])
  end

  # GET /core/logistics/new
  def new
    @core_logistic = Core::Logistic.new
  end

  # GET /core/logistics/1/edit
  def edit
  end

  # POST /core/logistics
  # POST /core/logistics.json
  def create
    @core_logistic = Core::Logistic.new(core_logistic_params)

    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to(action: "index")}
        format.json { head :no_content}
      elsif @core_logistic.save
        format.html { redirect_to @core_logistic, notice: 'Logistic was successfully created.' }
        format.json { render action: 'show', status: :created, location: @core_logistic }
      else
        format.html { render action: 'new' }
        format.json { render json: @core_logistic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /core/logistics/1
  # PATCH/PUT /core/logistics/1.json
  def update
    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to @core_logistic}
        format.json { head :no_content }
      elsif @core_logistic.update(core_logistic_params)
        format.html { redirect_to @core_logistic, notice: 'Logistic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @core_logistic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /core/logistics/1
  # DELETE /core/logistics/1.json
  def destroy
    @core_logistic.destroy
    respond_to do |format|
      format.html { redirect_to core_logistics_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_core_logistic
    @core_logistic = Core::Logistic.find_by_id(params[:id])
    redirect_to(action: "index") and redirect_to if @core_logistic.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def core_logistic_params
    params.require(:core_logistic).permit(:name).merge({account_id: current_account.id, updater_id: current_user.id})
  end
end
