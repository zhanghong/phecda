class Sys::CategoriesController < ApplicationController
  before_action :set_sys_category, only: [:show, :edit, :update, :destroy]

  # GET /sys/categories
  # GET /sys/categories.json
  def index
    @sys_categories = Sys::Category.find_mine(params).roots
  end

  # GET /sys/categories/1
  # GET /sys/categories/1.json
  def show
  end

  # GET /sys/categories/new
  def new
    @sys_category = Sys::Category.new
  end

  # GET /sys/categories/1/edit
  def edit
  end

  # POST /sys/categories
  # POST /sys/categories.json
  def create
    @sys_category = Sys::Category.new(sys_category_params)

    respond_to do |format|
      if @sys_category.save
        @sys_category.save_property_values(params[:property_ids])
        format.html { redirect_to @sys_category, notice: 'Category was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sys_category }
      else
        format.html { render action: 'new' }
        format.json { render json: @sys_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sys/categories/1
  # PATCH/PUT /sys/categories/1.json
  def update
    respond_to do |format|
      if @sys_category.update(sys_category_params)
        @sys_category.save_property_values(params[:property_ids])
        format.html { redirect_to @sys_category, notice: 'Category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sys_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sys/categories/1
  # DELETE /sys/categories/1.json
  def destroy
    @sys_category.destroy
    respond_to do |format|
      format.html { redirect_to sys_categories_url }
      format.json { head :no_content }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_sys_category
    @sys_category = Sys::Category.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sys_category_params
    params.require(:sys_category).permit(:name, :status, :parent_id).merge({account_id: current_account.id, user_id: current_user.id})
  end
end
