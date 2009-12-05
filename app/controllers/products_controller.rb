class ProductsController < ApplicationController

  def index
    @product = Product.find_by_barcode(params[:q])
    if @product.blank?
      set_metadata(:page_title => "Enter a new product",:description => "Help howgoodismyfood.com by adding more products to the database")
      @product = Product.new
      render :new
    else
      set_metadata(:page_title => @product.name,:description => "#{@production.name} truth behind nutrional values")
      render :show
    end
  end

  def new
    @product = Product.new
  end

  def show
    @product = Product.find(params[:id])
    set_metadata(:page_title => @product.name,:description => "#{@product.name} truth behind nutrional values")
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
