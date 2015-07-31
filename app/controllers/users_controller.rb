class UsersController < ApplicationController

  include UserSessionsHelper
  
  before_filter :require_user, :only => [:edit, :update, :index, :voucher, :credit]
  
  helper_method :brute_force
  
  def brute_force
    if session[:bad_voucher].blank? || session[:bad_voucher].to_i < 0
      session[:bad_voucher] = 1
    else
      session[:bad_voucher] += 1
    end
    if session[:bad_voucher] > 9
      current_user.update_attribute(:redeem_disabled, true)
    end
  end

  def index
  
  end
    
  def activate_voucher
    order_item = OrderItem.find_by_code(params[:code])
    if current_user.redeem_disabled? 
      flash[:error] = "Your account had been disabled from redeeming vouchers, please contact us to have it re-enabled."
      render :action => "voucher"
      return
    end
    if order_item.nil?
      flash[:error] = "Cannot find voucher"
      render :action => "voucher"
      flash[:error] = nil
      brute_force
    elsif order_item.used?
      brute_force
      flash[:error] = "Voucher has already been used"
      render :action => "voucher"
      flash[:error] = nil
    else
      order_item.use(current_user)
      flash[:notice] = "Code Activated"
      redirect_to :action => "credit"
      flash[:notice] = nil
    end
  end

  def new
    @user = User.new
  end  

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully registered."
      if @current_basket && @current_basket.basket_items.length > 0
        redirect_to :controller => "baskets", :action => "set_user"    
      else 
        redirect_to users_path
      end
    else
      render :action => 'new'
    end
  end  

  def edit  
    @user = current_user  
  end  
    
  def update  
    @user = current_user  
    if @user.update_attributes(params[:user])  
      flash[:notice] = "Successfully updated profile."  
      redirect_to root_url  
    else  
      render :action => 'edit'  
    end  
  end   
end
