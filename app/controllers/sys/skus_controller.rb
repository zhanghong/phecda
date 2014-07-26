class Sys::SkusController < ApplicationController
  before_action :set_sys_sku, only: [:show, :edit, :update, :destroy]

  # # GET /sys/skus
  # # GET /sys/skus.json
  # def index
  #   @sys_skus = Sys::Sku.all
  # end

  # GET /sys/skus/1
  # GET /sys/skus/1.json
  def show
    @sku_bindings = @sys_sku.sku_bindings
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  # GET /sys/skus/new
  def new
    sys_product = Sys::Product.find_mine(id: params[:product_id].to_i).first
    @sys_sku = sys_product.skus.build(price: sys_product.price) if sys_product.present?
    edit_relate
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  # GET /sys/skus/1/edit
  def edit
    @sys_properties = @sys_sku.product.category.properties

    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  # POST /sys/skus
  # POST /sys/skus.json
  def create
    @sys_sku = Sys::Sku.new(sys_sku_params)

    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to @sys_sku, notice: 'Sku was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sys_sku }
        format.js {}
      elsif @sys_sku.save
        format.html { redirect_to @sys_sku, notice: 'Sku was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sys_sku }
        format.js {}
      else
        edit_relate

        format.html { render action: 'new' }
        format.json { render json: @sys_sku.errors, status: :unprocessable_entity }
        format.js { render action: 'new'}
      end
    end
  end

  # PATCH/PUT /sys/skus/1
  # PATCH/PUT /sys/skus/1.json
  def update
    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to @sys_sku, notice: 'Sku was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sys_sku }
        format.js {}
      elsif @sys_sku.update(sys_sku_params)
        format.html { redirect_to @sys_sku, notice: 'Sku was successfully updated.' }
        format.json { head :no_content }
        format.js {}
      else
        edit_relate

        format.html { render action: 'edit' }
        format.json { render json: @sys_sku.errors, status: :unprocessable_entity }
        format.js { render action: 'edit'}
      end
    end
  end

  # DELETE /sys/skus/1
  # DELETE /sys/skus/1.json
  def destroy
    @sys_sku.destroy
    respond_to do |format|
      format.html { redirect_to sys_skus_url }
      format.json { head :no_content }
      format.js {}
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_sys_sku
    @sys_sku = Sys::Sku.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sys_sku_params
    params.require(:sys_sku).permit(:product_id, :name, :number, :price).merge({account_id: current_account.id, updater_id: current_user.id, pro_values_ids: params_pro_values_ids})
  end

  def params_pro_values_ids
    if params[:pro_values_ids].is_a?(Hash)
      params[:pro_values_ids].values
    else
      []
    end
  end

  def edit_relate
    @sys_properties = @sys_sku.product.category.properties
  end
end
