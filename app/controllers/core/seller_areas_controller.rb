class Core::SellerAreasController < ApplicationController
  before_action :set_core_seller_area, only: [:show, :edit, :update, :destroy]
  before_action :find_from_objects,  only: [:new, :edit]

  # GET /core/seller_areas
  # GET /core/seller_areas.json
  def index
    @core_seller_areas = Core::SellerArea.find_mine(params).paginate(page: params[:page])
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  def area_nodes
    @seller_areas_id = Core::SellerArea.find_mine(seller_id: params[:seller_id]).map(&:area_id)
    @core_areas = Core::Area.find_mine(parent_id: params[:id])
  end

  def node_click
    @seller_areas_id = Core::SellerArea.find_mine(seller_id: params[:seller_id]).map(&:area_id)
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  # # GET /core/seller_areas/1
  # # GET /core/seller_areas/1.json
  # def show
  # end

  # GET /core/seller_areas/new
  def new
    attrs = {}
    [:area_id, :seller_id].each do |name|
      attrs[name] = params[name] if params[name].present?
    end
    @core_seller_area = Core::SellerArea.new(attrs)
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  # # GET /core/seller_areas/1/edit
  # def edit
  # end

  # POST /core/seller_areas
  # POST /core/seller_areas.json
  def create
    @core_seller_area = Core::SellerArea.new(core_seller_area_params)

    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to(action: "index")}
        format.json { head :no_content}
        format.js {}
      elsif @core_seller_area.save
        format.html { redirect_to @core_seller_area, notice: 'Seller area was successfully created.' }
        format.json { render action: 'show', status: :created, location: @core_seller_area }
        format.js { find_relates_by_from }
      else
        format.html { render action: 'new' }
        format.json { render json: @core_seller_area.errors, status: :unprocessable_entity }
        format.js do 
          find_from_objects
          render action: 'new'
        end
      end
    end
  end

  # # PATCH/PUT /core/seller_areas/1
  # # PATCH/PUT /core/seller_areas/1.json
  # def update
  #   respond_to do |format|
  #     if params[:btn_cancel].present?
  #       format.html { redirect_to @core_seller_area}
  #       format.json { head :no_content }
  #     elsif @core_seller_area.update(core_seller_area_params)
  #       format.html { redirect_to @core_seller_area, notice: 'Seller area was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @core_seller_area.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /core/seller_areas/1
  # DELETE /core/seller_areas/1.json
  def destroy
    @core_seller_area.destroy
    respond_to do |format|
      format.html { redirect_to core_seller_areas_url }
      format.json { head :no_content }
      format.js do
        find_relates_by_from
      end
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_core_seller_area
    @core_seller_area = Core::SellerArea.find_by_id(params[:id])
    redirect_to(action: "index") and redirect_to if @core_seller_area.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def core_seller_area_params
    params.require(:core_seller_area).permit(:seller_id, :area_id).merge({account_id: current_account.id, updater_id: current_user.id})
  end

  def find_from_objects
    case params[:from]
    when "area"
      @core_sellers = Core::Seller.all
    when "seller"
      @core_areas = Core::Area.roots
    end
  end

  def find_relates_by_from
    conditions =  case params[:from]
                  when "seller"
                    {seller_id: @core_seller_area.seller_id}
                  when "area"
                    {area_id: @core_seller_area.area_id}
                  else
                    {id: 0}
                  end
    @core_seller_areas = Core::SellerArea.find_mine(conditions).paginate(page: params[:page])
  end
end