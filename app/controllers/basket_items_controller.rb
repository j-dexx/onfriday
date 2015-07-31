class BasketItemsController < ApplicationController

  before_filter :load_voucher_page_node, :only => [:new, :create, :edit, :update]
  before_filter :load_donation_page_node, :only => [:new_donation, :create_donation, :edit_donation, :update_donation]
  before_filter :initialize_basket, :only => [:create, :create_donation]
  
  def load_voucher_page_node
    @page_node = PageNode.find_by_name("Gift Voucher")
  end
  
  def load_donation_page_node
    @page_node = PageNode.find_by_name("New Donation")
    @donation_page = DonationPage.find(params[:donation_page_id]) if params[:donation_page_id]
  end

  def new
    @basket_item = BasketItem.new(:basket_item_type => 1, :value => nil)
  end
  
  def new_donation
    @basket_item = BasketItem.new(:basket_item_type => 2, :value => nil)
  end
  
  def create
    @basket_item = BasketItem.new(params[:basket_item].merge!(:basket_item_type => 1, :basket_id => current_basket.id))
    if @basket_item.save
      redirect_to :controller => "baskets", :action => "index"
    else
      render :action => "new"
    end
  end
  
  def create_donation
    @basket_item = BasketItem.new(params[:basket_item].merge!(:basket_item_type => 2, :basket_id => current_basket.id))
    @basket_item.target_id = params[:donation_page_id]
    if @basket_item.save
      redirect_to :controller => "baskets", :action => "index"
    else
      render :action => "new_donation"
    end
  end
  
  def edit
    @basket_item = BasketItem.find(params[:id])
    unless @basket_item.basket == current_basket && @basket_item.voucher?
      flash[:error] = "You do not have permission to edit this item"
      redirect_to root_path    
    end
  end
  
  def edit_donation
    @basket_item = BasketItem.find(params[:id])
    unless @basket_item.basket == current_basket && @basket_item.donation?
      flash[:error] = "You do not have permission to edit this item"
      redirect_to root_path    
    end
  end
  
  def update
    @basket_item = BasketItem.find(params[:id])
    unless @basket_item.basket == current_basket && @basket_item.voucher?
      flash[:error] = "You do not have permission to edit this item"
      redirect_to root_path    
    end
    if @basket_item.update_attributes(params[:basket_item])
      redirect_to :controller => "baskets", :action => "index"
    else
      render :action => "edit"    
    end
  end
  
  def update_donation
    @basket_item = BasketItem.find(params[:id])
    unless @basket_item.basket == current_basket && @basket_item.donation?
      flash[:error] = "You do not have permission to edit this item"
      redirect_to root_path    
    end
    if @basket_item.update_attributes(params[:basket_item])
      redirect_to :controller => "baskets", :action => "index"
    else
      render :action => "edit_donation"    
    end
  end
  
end
