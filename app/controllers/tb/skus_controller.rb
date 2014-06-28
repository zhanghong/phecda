class Tb::SkusController < ApplicationController
#   before_action :set_tb_sku, only: [:show, :edit, :update, :destroy]

#   # GET /tb/skus
#   # GET /tb/skus.json
#   def index
#     @tb_skus = Tb::Sku.all
#   end

#   # GET /tb/skus/1
#   # GET /tb/skus/1.json
#   def show
#   end

#   # GET /tb/skus/new
#   def new
#     @tb_sku = Tb::Sku.new
#   end

#   # GET /tb/skus/1/edit
#   def edit
#   end

#   # POST /tb/skus
#   # POST /tb/skus.json
#   def create
#     @tb_sku = Tb::Sku.new(tb_sku_params)

#     respond_to do |format|
#       if @tb_sku.save
#         format.html { redirect_to @tb_sku, notice: 'Sku was successfully created.' }
#         format.json { render action: 'show', status: :created, location: @tb_sku }
#       else
#         format.html { render action: 'new' }
#         format.json { render json: @tb_sku.errors, status: :unprocessable_entity }
#       end
#     end
#   end

#   # PATCH/PUT /tb/skus/1
#   # PATCH/PUT /tb/skus/1.json
#   def update
#     respond_to do |format|
#       if @tb_sku.update(tb_sku_params)
#         format.html { redirect_to @tb_sku, notice: 'Sku was successfully updated.' }
#         format.json { head :no_content }
#       else
#         format.html { render action: 'edit' }
#         format.json { render json: @tb_sku.errors, status: :unprocessable_entity }
#       end
#     end
#   end

#   # DELETE /tb/skus/1
#   # DELETE /tb/skus/1.json
#   def destroy
#     @tb_sku.destroy
#     respond_to do |format|
#       format.html { redirect_to tb_skus_url }
#       format.json { head :no_content }
#     end
#   end

# private
#   # Use callbacks to share common setup or constraints between actions.
#   def set_tb_sku
#     @tb_sku = Tb::Sku.find(params[:id])
#   end

#   # Never trust parameters from the scary internet, only allow the white list through.
#   def tb_sku_params
#     params.require(:tb_sku).permit(:ts_id, :product_id, :quantity)
#   end
end
