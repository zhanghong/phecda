class Sys::ProductsController < ApplicationController
  def index
    @sys_products = Sys::Product.all
    @accounts = Account.all
  end

  def show
  end

  def new
  end

  def create
  end

  def update
  end

  def edit
  end

  def destroy
  end
end
