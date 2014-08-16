# encoding : utf-8 -*-
class Core::StockInBillsController < ApplicationController
  before_action :find_core_stock
  before_action :set_core_stock_in_bill, only: [:show, :edit, :update, :destroy]
  authorize_resource  :class => Core::StockInBill

  # GET /core/stock_in_bills
  # GET /core/stock_in_bills.json
  def index
    @core_stock_in_bills = Core::StockInBill.find_mine(params).paginate(page: params[:page])
  end

  # GET /core/stock_in_bills/1
  # GET /core/stock_in_bills/1.json
  def show
    @bill_products = @core_stock_in_bill.bill_products
    @logs = @core_stock_in_bill.logs
  end

  # GET /core/stock_in_bills/new
  def new
    @core_stock_in_bill = @core_stock.stock_in_bills.build
  end

  # GET /core/stock_in_bills/1/edit
  def edit
  end

  # POST /core/stock_in_bills
  # POST /core/stock_in_bills.json
  def create
    @core_stock_in_bill = @core_stock.stock_in_bills.build(core_stock_in_bill_params)

    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to core_stock_stock_in_bills_path(@core_stock)}
        format.json { head :no_content}
      elsif @core_stock_in_bill.save
        format.html { redirect_to core_stock_stock_in_bill_path(@core_stock, @core_stock_in_bill), notice: '创建成功' }
        format.json { render action: 'show', status: :created, location: @core_stock_in_bill }
      else
        format.html { render action: 'new' }
        format.json { render json: @core_stock_in_bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /core/stock_in_bills/1
  # PATCH/PUT /core/stock_in_bills/1.json
  def update
    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to core_stock_stock_in_bill_path(@core_stock, @core_stock_in_bill)}
        format.json { head :no_content }
      elsif @core_stock_in_bill.update(core_stock_in_bill_params)
        format.html { redirect_to core_stock_stock_in_bill_path(@core_stock, @core_stock_in_bill), notice: '更新成功' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @core_stock_in_bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /core/stock_in_bills/1
  # DELETE /core/stock_in_bills/1.json
  def destroy
    # @core_stock_in_bill.destroy
    # respond_to do |format|
    #   format.html { redirect_to core_stock_in_bills_url }
    #   format.json { head :no_content }
    # end
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_core_stock_in_bill
    @core_stock_in_bill = Core::StockInBill.where(stock_id: params[:stock_id], id: params[:id]).first
    redirect_to(action: "index") and return if @core_stock_in_bill.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def core_stock_in_bill_params
    params.require(:core_stock_in_bill).permit(:stock_id, :cat_name, :customer_name, :area_id, :address, :mobile, :phone, :remark).merge({account_id: current_account.id, updater_id: current_user.id})
  end
end
