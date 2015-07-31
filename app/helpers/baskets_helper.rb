module BasketsHelper

  def search_link
    searches = [search_brand, search_type, search_colour, search_material].delete_if{|x| x.blank? }
    if searches.length <= 0
      "Back to Search"
    else
      "Search :: #{searches.join(' :: ')}"
    end
  end
  
  def search_brand
    if !params[:search][:brand].nil?
      params[:search][:brand]
    elsif session[:product_search] && session[:product_search][:search] && session[:product_search][:search][:brand]
      session[:product_search][:search][:brand]
    else
      ""
    end
  end
  
  def search_type
    if !params[:search][:taggable_with_types].nil?
      params[:search][:taggable_with_types]
    elsif session[:product_search] && session[:product_search][:search] && session[:product_search][:search][:taggable_with_types]
      session[:product_search][:search][:taggable_with_types]
    else
     ""
    end
  end
  
  def search_colour
    if !params[:search][:taggable_with_colours].nil?
      params[:search][:taggable_with_colours]
    elsif session[:product_search] && session[:product_search][:search] && session[:product_search][:search][:taggable_with_colours]
      session[:product_search][:search][:taggable_with_colours]
    else
     ""
    end
  end
  
  def search_material
    if !params[:search][:taggable_with_materials].nil?
      params[:search][:taggable_with_materials]
    elsif session[:product_search] && session[:product_search][:search] && session[:product_search][:search][:taggable_with_materials]
      session[:product_search][:search][:taggable_with_materials]
    else
     ""
    end
  end 
  
  def search_price
    if !params[:search][:price_range].nil?
      params[:search][:price_range]
    elsif session[:product_search] && session[:product_search][:search] && session[:product_search][:search][:price_range]
      session[:product_search][:search][:price_range]
    else
     ""
    end
  end
  
  def search_upcycled 
    if !params[:search][:upcycled].nil?
      params[:search][:upcycled]
    elsif session[:product_search] && session[:product_search][:search] && session[:product_search][:search][:upcycled]
      session[:product_search][:search][:upcycled]
    else
     ""
    end
  end

  def search_fair_trade
    if !params[:search][:fair_trade].nil?
      params[:search][:fair_trade]
    elsif session[:product_search] && session[:product_search][:search] && session[:product_search][:search][:fair_trade]
      session[:product_search][:search][:fair_trade]
    else
     ""
    end
  end
  
  def search_men
    if !params[:search][:men].nil?
      params[:search][:men]
    elsif session[:product_search] && session[:product_search][:search] && session[:product_search][:search][:men]
      session[:product_search][:search][:men]
    else
     ""
    end  
  end
  
  def search_women
    if !params[:search][:women].nil?
      params[:search][:women]
    elsif session[:product_search] && session[:product_search][:search] && session[:product_search][:search][:women]
      session[:product_search][:search][:women]
    else
     ""
    end
  end
  
end
