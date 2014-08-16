# encoding : utf-8 -*-
class Core::StockBillsController < ApplicationController
  before_action :find_core_stock
  before_action :set_core_stock_bill, only: [:show, :edit, :update, :destroy]
  authorize_resource  :class => Core::StockBill

  # GET /core/stock_bills
  # GET /core/stock_bills.json
  def index
    @core_stock_bills = Core::StockBill.find_mine(params).paginate(page: params[:page])
  end

  # # GET /core/stock_bills/1
  # # GET /core/stock_bills/1.json
  # def show
  # end

#   # GET /core/stock_bills/new
#   def new
#     @core_stock_bill = Core::StockBill.new
#   end

#   # GET /core/stock_bills/1/edit
#   def edit
#   end

#   # POST /core/stock_bills
#   # POST /core/stock_bills.json
#   def create
#     @core_stock_bill = Core::StockBill.new(core_stock_bill_params)

#     respond_to do |format|
#       if @core_stock_bill.save
#         format.html { redirect_to @core_stock_bill, notice: 'Stock bill was successfully created.' }
#         format.json { render action: 'show', status: :created, location: @core_stock_bill }
#       else
#         format.html { render action: 'new' }
#         format.json { render json: @core_stock_bill.errors, status: :unprocessable_entity }
#       end
#     end
#   end

#   # PATCH/PUT /core/stock_bills/1
#   # PATCH/PUT /core/stock_bills/1.json
#   def update
#     respond_to do |format|
#       if @core_stock_bill.update(core_stock_bill_params)
#         format.html { redirect_to @core_stock_bill, notice: 'Stock bill was successfully updated.' }
#         format.json { head :no_content }
#       else
#         format.html { render action: 'edit' }
#         format.json { render json: @core_stock_bill.errors, status: :unprocessable_entity }
#       end
#     end
#   end

#   # DELETE /core/stock_bills/1
#   # DELETE /core/stock_bills/1.json
#   def destroy
#     @core_stock_bill.destroy
#     respond_to do |format|
#       format.html { redirect_to core_stock_bills_url }
#       format.json { head :no_content }
#     end
#   end

# private
#   # Use callbacks to share common setup or constraints between actions.
#   def set_core_stock_bill
#     @core_stock_bill = Core::StockBill.find(params[:id])
#   end

#   # Never trust parameters from the scary internet, only allow the white list through.
#   def core_stock_bill_params
#     params.require(:core_stock_bill).permit(:stock_id, :cat_name, :status, :customer_name, :area_id, :address, :mobile, :phone, :remark)
#   end
end
