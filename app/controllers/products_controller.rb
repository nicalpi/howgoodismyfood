class ProductsController < ApplicationController

  def index
    @product = Product.find_by_barcode(params[:q])
    if @product.blank?
      @product = Product.new
      render :new
    else
      render :show
    end
  end

  def new
    @product = Product.new
  end

  def show
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(params[:product])
    
    if @product.save
      flash[:notice] = "Your product is now saved"
      redirect_to product_path(@product)
    else
      flash[:error] = "Seems something went wrong!"
      render :new
    end
  end
end
