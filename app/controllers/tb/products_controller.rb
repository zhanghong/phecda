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
  end

  # GET /tb/products/new
  def new
    @tb_product = Tb::Product.new
  end

  # GET /tb/products/1/edit
  def edit
  end

  # POST /tb/products
  # POST /tb/products.json
  def create
    @tb_product = Tb::Product.new(tb_product_params)

    respond_to do |format|
      if @tb_product.save
        format.html { redirect_to @tb_product, notice: 'Product was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tb_product }
      else
        format.html { render action: 'new' }
        format.json { render json: @tb_product.errors, status: :unprocessable_entity }
      end
    end
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

  # DELETE /tb/products/1
  # DELETE /tb/products/1.json
  def destroy
    @tb_product.destroy
    respond_to do |format|
      format.html { redirect_to tb_products_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_tb_product
    @tb_product = Tb::Product.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tb_product_params
    params.require(:tb_product).permit(:index, :show, :edit, :update)
  end
end
