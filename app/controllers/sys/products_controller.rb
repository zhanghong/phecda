class Sys::ProductsController < ApplicationController
  before_action :set_sys_product, only: [:show, :edit, :update, :destroy]

  # GET /sys/products
  # GET /sys/products.json
  def index
    @sys_products = Sys::Product.find_mine(params).paginate(page: params[:page])
  end

  # GET /sys/products/1
  # GET /sys/products/1.json
  def show
    @sys_skus = @sys_product.skus.all
    @sys_properties = @sys_product.category.properties
    @sys_sku = @sys_product.skus.build(price: @sys_product.price)
  end

  # GET /sys/products/new
  def new
    @sys_product = Sys::Product.new
  end

  # GET /sys/products/1/edit
  def edit
  end

  # POST /sys/products
  # POST /sys/products.json
  def create
    @sys_product = Sys::Product.new(sys_product_params)

    respond_to do |format|
      if @sys_product.save
        format.html { redirect_to @sys_product, notice: 'Product was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sys_product }
      else
        format.html { render action: 'new' }
        format.json { render json: @sys_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sys/products/1
  # PATCH/PUT /sys/products/1.json
  def update
    respond_to do |format|
      if params[:btn_cancel].present?
        format.js {}
      elsif @sys_product.update(sys_product_params)
        format.html { redirect_to @sys_product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
        format.js {}
      else
        format.js {render action: "edit"}
        format.html { render action: 'edit' }
        format.json { render json: @sys_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sys/products/1
  # DELETE /sys/products/1.json
  def destroy
    @sys_product.destroy
    respond_to do |format|
      format.html { redirect_to sys_products_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_sys_product
    @sys_product = Sys::Product.account_scope.actived.find_by_id(params[:id])
    redirect_to(sys_products) and return if @sys_product.nil?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sys_product_params
    params.require(:sys_product).permit(:title, :category_id, :price, :num, :description).merge({account_id: current_account.id, updater_id: current_user.id})
  end
end
