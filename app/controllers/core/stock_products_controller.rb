class Core::StockProductsController < ApplicationController
  before_action :set_core_stock_product, only: [:show, :edit, :update, :destroy]
  authorize_resource  :class => Core::StockProduct

  # GET /core/stock_products
  # GET /core/stock_products.json
  def index
    @core_stock_products = Core::StockProduct.find_mine(params).paginate(page: params[:page])
  end

  # GET /core/stock_products/1
  # GET /core/stock_products/1.json
  def show
  end

  # GET /core/stock_products/new
  def new
    @core_stock_product = Core::StockProduct.new
  end

  # GET /core/stock_products/1/edit
  def edit
  end

  # POST /core/stock_products
  # POST /core/stock_products.json
  def create
    @core_stock_product = Core::StockProduct.new(core_stock_product_params)

    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to(action: "index")}
        format.json { render json: {}}
      elsif @core_stock_product.save
        format.html { redirect_to @core_stock_product, notice: 'Stock product was successfully created.' }
        format.json { render action: 'show', status: :created, location: @core_stock_product }
      else
        format.html { render action: 'new' }
        format.json { render json: @core_stock_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /core/stock_products/1
  # PATCH/PUT /core/stock_products/1.json
  def update
    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to(@core_stock_product)}
        format.json { head :no_content }
      elsif @core_stock_product.update(core_stock_product_params)
        format.html { redirect_to @core_stock_product, notice: 'Stock product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @core_stock_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /core/stock_products/1
  # DELETE /core/stock_products/1.json
  def destroy
    @core_stock_product.destroy
    respond_to do |format|
      format.html { redirect_to core_stock_products_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_core_stock_product
    @core_stock_product = Core::StockProduct.account_scope.actived.find_by_id(params[:id])
    redirect_to(action: "index") and return if @core_stock_product.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def core_stock_product_params
    params.require(:core_stock_product).permit(:stock_id, :sys_product_id, :sys_sku_id, :activite_num, :actual_num).merge({account_id: current_account.id, updater_id: current_user.id})
  end
end
