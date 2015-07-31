class ProductsController < ApplicationController

  include BasketsHelper

  def search
    redirect_to :action => "index", :search => params[:search]#.delete_if{|k,v| v.blank? || v == "0"}
  end
  
  def index_clean
    search = {
      :men => "false",
      :women => "false",
      :brand => nil,
      :taggable_with_types => nil,
      :taggable_with_colours => nil, 
      :taggable_with_materials => nil,
      :price_range => nil,
      :upcycled => nil,
      :fair_trade => nil
    }
    redirect_to :action => "index", :search => search
  end

  def index
    params[:search] ||= {}
        
    # ensure that you can only view men or womens bags
    if params[:search][:men] == "true"
      @men = true
      session[:product_search] ||= {}
      session[:product_search][:search] ||= {}
      session[:product_search][:search][:women] = "false"
    elsif params[:search][:women] == "true"
      @women = true
      session[:product_search] ||= {}
      session[:product_search][:search] ||= {}
      session[:product_search][:search][:men] = "false"
    else
      @no_gender = true
    end
    
    # set the params to session versions if they are nil
    params[:search][:brand] = search_brand
    params[:search][:taggable_with_types] = search_type
    params[:search][:taggable_with_colours] = search_colour
    params[:search][:taggable_with_materials] = search_material
    params[:search][:price_range] = search_price
    params[:search][:upcycled] = search_upcycled
    params[:search][:fair_trade] = search_fair_trade
    params[:search][:men] = search_men
    params[:search][:women] = search_women
    
    # store the search in the session
    session[:product_search] = params
    
    if params[:search][:order].nil?
      @search = Product.active.position.search(params[:search])
    else
      @search = Product.active.search(params[:search])
    end
    @products = @search.paginate(:page => params[:page], :per_page => 12)
  end  

  def show
    params[:search] ||= {}
    @search = Product.active.search(params[:search])
    @product = Product.find(params[:id])
    @product_images = @product.product_images.select{|x| x.active?}.sort_by{|x| x.position}
  end
  
  def new
    @new_in = true
    params[:search] ||= {:new_in_equals => true}
    @search = Product.search(params[:search])
    @products = @search.paginate(:page => params[:page], :per_page => 12)
    render :action => 'index' 
  end
  
  def sale
    @sale = true
    params[:search] ||= {:sale_equals => true}
    @search = Product.search(params[:search])
    @products = @search.paginate(:page => params[:page], :per_page => 12)
    render :action => 'index' 
  end
  
end
