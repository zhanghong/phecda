class Core::SellersController < ApplicationController
  before_action :set_core_seller, only: [:show, :edit, :update, :destroy]

  # GET /core/sellers
  # GET /core/sellers.json
  def index
    @core_sellers = Core::Seller.find_mine(params).paginate(page: params[:page])
  end

  # GET /core/sellers/1
  # GET /core/sellers/1.json
  def show
    @core_seller_areas = Core::SellerArea.find_mine(seller_id: @core_seller.id).paginate(page: params[:page])
  end

  # GET /core/sellers/new
  def new
    @core_seller = Core::Seller.new
  end

  # GET /core/sellers/1/edit
  def edit
  end

  # POST /core/sellers
  # POST /core/sellers.json
  def create
    @core_seller = Core::Seller.new(core_seller_params)

    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to(action: "index")}
        format.json { head :no_content}
      elsif @core_seller.save
        format.html { redirect_to @core_seller, notice: 'Seller was successfully created.' }
        format.json { render action: 'show', status: :created, location: @core_seller }
      else
        format.html { render action: 'new' }
        format.json { render json: @core_seller.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /core/sellers/1
  # PATCH/PUT /core/sellers/1.json
  def update
    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to @core_seller}
        format.json { head :no_content }
      elsif @core_seller.update(core_seller_params)
        format.html { redirect_to @core_seller, notice: 'Seller was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @core_seller.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /core/sellers/1
  # DELETE /core/sellers/1.json
  def destroy
    @core_seller.destroy
    respond_to do |format|
      format.html { redirect_to core_sellers_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_core_seller
    @core_seller = Core::Seller.find_by_id(params[:id])
    redirect_to(action: "index") and return if @core_seller.nil? 
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def core_seller_params
    params.require(:core_seller).permit(:parent_id, :name, :fullname, :mobile, :phone, :email, :address, :stock_id).merge({account_id: current_account.id, updater_id: current_user.id})
  end
end
