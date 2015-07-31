class Admin::BasketsController < Admin::AdminController

  def index
    params[:search] ||= {}
    params[:search][:order] ||= "descend_by_created_at"
    @search = Basket.search(params[:search])
    @baskets = @search

    if params[:search][:basket_type] == "ready"
      @baskets = @baskets.select{|x| x.payment_ready? }
    elsif params[:search][:basket_type] == "not empty"
      @baskets = @baskets.select{|x| x.basket_items.length > 0 }
    elsif params[:search][:basket_type] == "kept"
      @baskets = @baskets.select{|x| x.keep? }
    end
    
    if params[:search][:order] == "ascend_by_ready"
      @baskets = @baskets.sort_by{|x| x.payment_ready?.to_s }.reverse
    elsif params[:search][:order] == "descend_by_ready"
      @baskets = @baskets.sort_by{|x| x.payment_ready?.to_s }
    elsif params[:search][:order] == "ascend_by_basket_items_length"
      @baskets = @baskets.sort_by{|x| x.basket_items.length }
    elsif params[:search][:order] == "descend_by_basket_items_length"
      @baskets = @baskets.sort_by{|x| x.basket_items.length }.reverse
    end
    
    @baskets = @baskets.paginate(:page => params[:page], :per_page => 50)    
  end  

  def destroy
    @basket = Basket.find(params[:id])
    @basket.destroy
    flash[:notice] = "Successfully destroyed basket."
    redirect_to admin_baskets_path
  end
  
  def convert_to_order
    @basket = Basket.find(params[:id])
    if params[:skip_email] == "true"
      order = @basket.convert_to_order("Paid (Admin)", {:type => "Admin Payment"}, true)
    else
      order = @basket.convert_to_order("Paid (Admin)", {:type => "Admin Payment"})
    end
    flash[:notice] = "Order placed"
    redirect_to admin_orders_path
  end
  
  def keep
    @basket = Basket.find(params[:id])
    @basket.update_attribute(:keep, true)
    redirect_to edit_admin_basket_path(@basket)
  end
  
  def edit
    @basket = Basket.find(params[:id])
  end
end
