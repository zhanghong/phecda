class Core::StocksController < ApplicationController
  before_action :set_core_stock, only: [:show, :edit, :update, :destroy]
  authorize_resource  :class => Core::Stock

  # GET /core/stocks
  # GET /core/stocks.json
  def index
    @core_stocks = Core::Stock.find_mine(params).paginate(page: params[:page])
  end

  # GET /core/stocks/1
  # GET /core/stocks/1.json
  def show
  end

  # GET /core/stocks/new
  def new
    @core_stock = Core::Stock.new
  end

  # GET /core/stocks/1/edit
  def edit
  end

  # POST /core/stocks
  # POST /core/stocks.json
  def create
    @core_stock = Core::Stock.new(core_stock_params)

    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to(action: "index")}
        format.json { render json: {}}
      elsif @core_stock.save
        format.html { redirect_to @core_stock, notice: 'Stock was successfully created.' }
        format.json { render action: 'show', status: :created, location: @core_stock }
      else
        format.html { render action: 'new' }
        format.json { render json: @core_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /core/stocks/1
  # PATCH/PUT /core/stocks/1.json
  def update
    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to(@core_stock)}
        format.json { head :no_content }
      elsif @core_stock.update(core_stock_params)
        format.html { redirect_to @core_stock, notice: 'Stock was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @core_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /core/stocks/1
  # DELETE /core/stocks/1.json
  def destroy
    @core_stock.destroy
    respond_to do |format|
      format.html { redirect_to core_stocks_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_core_stock
    @core_stock = Core::Stock.account_scope.actived.find_by_id(params[:id])
    redirect_to(action: "index") and return if @core_stock.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def core_stock_params
    params.require(:core_stock).permit(:name).merge({account_id: current_account.id, updater_id: current_user.id})
  end
end
