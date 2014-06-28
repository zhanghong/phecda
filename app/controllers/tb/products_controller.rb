class Tb::ProductsController < ApplicationController
  before_action :set_tb_product, only: [:show, :edit, :update, :destroy]

  # GET /tb/products
  # GET /tb/products.json
  def index
    @tb_products = Tb::Product.find_mine(params).paginate(page: params[:page])
  end

  # GET /tb/products/1
  # GET /tb/products/1.json
  def show
    @skus = @tb_product.skus
  end

  # GET /tb/products/1/edit
  def edit

  end

  # PATCH/PUT /tb/products/1
  # PATCH/PUT /tb/products/1.json
  def update
    respond_to do |format|
      if @tb_product.update(tb_product_params)
        format.html { redirect_to @tb_product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tb_product.errors, status: :unprocessable_entity }
      end
    end
  end
private
  # Use callbacks to share common setup or constraints between actions.
  def set_tb_product
    @tb_product = Tb::Product.find(params[:id])
    redirect_to(tb_products_path) and return if @tb_product.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tb_product_params
    # params.require(:tb_product).permit(:index, :show, :edit, :update)
  end
end
