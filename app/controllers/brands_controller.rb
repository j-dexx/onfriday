class BrandsController < ApplicationController

  def show
    @brand = Brand.find(params[:id])
    @brand_products = @brand.products
    @brands = Brand.active.position
    @next_brand = @brands[@brands.rindex(@brand)+1] if @brands[@brands.rindex(@brand)+1]
    @previous_brand = @brands[@brands.rindex(@brand)-1] if @brands[@brands.rindex(@brand)-1] && @brands[@brands.rindex(@brand)-1] != @brands.last
  end
  
  def index
    @search = Brand.active.position.search(params[:search])
    @brands = @search.paginate(:page => params[:page])
  end
  
end
