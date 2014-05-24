class ProductsController < ApplicationController
  before_action :set_sys_product, only: [:show, :edit, :update, :destroy]
  def index
    @sys_product = Sys::Product.all
  end

  def show
  end

  def new
    @sys_product = Sys::Product.new
  end

  def create
    @sys_product = Sys::Product.new(sys_product_params)

    respond_to do |format|
      if @sys_product.save
        format.html { redirect_to @sys_product, notice: 'Account was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sys_product }
      else
        format.html { render action: 'new' }
        format.json { render json: @sys_product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @sys_product.update(sys_product_params)
        format.html { redirect_to @sys_product, notice: 'Account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sys_product.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def destroy
    @sys_product.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url }
      format.json { head :no_content }
    end
  end
private
  # Use callbacks to share common setup or constraints between actions.
  def sys_product_params
    @sys_product = Sys::Product.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sys_product_params
    params.require(:product).permit(:category_id, :title, :num)
  end
end
