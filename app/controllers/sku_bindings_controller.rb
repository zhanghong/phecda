class SkuBindingsController < ApplicationController
  before_action :set_sku_binding, only: [:show, :edit, :update, :destroy]
  before_action :find_from_objects,  only: [:new, :edit]

  # GET /sku_bindings
  # GET /sku_bindings.json
  def index
    @sku_bindings = SkuBinding.all
  end

  # GET /sku_bindings/1
  # GET /sku_bindings/1.json
  def show
  end

  # GET /sku_bindings/new
  def new
    attrs = {}
    [:sku_id, :sys_sku_id].each do |attr_name|
      attrs[attr_name] = params[attr_name] if params[attr_name].present?
    end
    @sku_binding = SkuBinding.new(attrs)

    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  # GET /sku_bindings/1/edit
  def edit
    
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  # POST /sku_bindings
  # POST /sku_bindings.json
  def create
    @sku_binding = SkuBinding.new(sku_binding_params)
    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to @sku_binding}
        format.json { render action: 'show', status: :created, location: @sku_binding }
        format.js {}
      elsif @sku_binding.save
        format.html { redirect_to @sku_binding, notice: 'Sku binding was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sku_binding }
        format.js {}
      else
        find_from_objects
        format.html { render action: 'new' }
        format.json { render json: @sku_binding.errors, status: :unprocessable_entity }
        format.js {render action: 'new' }
      end
    end
  end

  # PATCH/PUT /sku_bindings/1
  # PATCH/PUT /sku_bindings/1.json
  def update
    respond_to do |format|
      if params[:btn_cancel].present?
        format.html { redirect_to @sku_binding}
        format.json { head :no_content }
        format.js {}
      elsif @sku_binding.update(sku_binding_params)
        format.html { redirect_to @sku_binding, notice: 'Sku binding was successfully updated.' }
        format.json { head :no_content }
        format.js {}
      else
        find_from_objects
        format.html { render action: 'edit' }
        format.json { render json: @sku_binding.errors, status: :unprocessable_entity }
        format.js { render action: 'edit'}
      end
    end
  end

  # DELETE /sku_bindings/1
  # DELETE /sku_bindings/1.json
  def destroy
    case params[:from]
    when "sys_sku"
      @sys_sku = @sku_binding.sys_sku
    when "tb_sku"
      @sku = @sku_binding.sku
    end
    @sku_binding.destroy
    respond_to do |format|
      format.html { redirect_to sku_bindings_url }
      format.json { head :no_content }
      format.js {}
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_sku_binding
    @sku_binding = SkuBinding.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sku_binding_params
    params.require(:sku_binding).permit(:sku_id, :sys_sku_id, :sys_sku_number).merge({account_id: current_account.id, updater_id: current_user.id})
  end

  def find_from_objects
    case params[:from]
    when "sys_sku"
      @skus = Sku.find_mine
      @form_name = "sys_sku_form"
    when "tb_sku"
      @sys_skus = Sys::Sku.find_mine
      @form_name = "sku_form"
    end
  end
end
