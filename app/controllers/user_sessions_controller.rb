class UserSessionsController < ApplicationController

  def index
    redirect_to :action => "new"
  end

  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      if session[:target]
        redirect_to session[:target]
        session[:target] = nil
      elsif @current_basket && @current_basket.basket_items.length > 0
        redirect_to :controller => "baskets", :action => "set_user"    
      else 
        redirect_to users_path
      end
    else
      render :action => "new"
    end
  end
    
  def destroy  
    @user_session = UserSession.find
    if @user_session  
      @user_session.destroy
      flash[:notice] = "Successfully logged out."  
      if @current_basket && @current_basket.basket_items.length > 0
        @current_basket.delivery_summary = nil
        @current_basket.billing_surname = nil
        @current_basket.billing_first_names = nil
        @current_basket.billing_address_1 = nil
        @current_basket.billing_address_2 = nil
        @current_basket.billing_city = nil
        @current_basket.billing_postcode = nil
        @current_basket.billing_country = nil
        @current_basket.delivery_first_names = nil
        @current_basket.delivery_surname = nil
        @current_basket.delivery_address_1 = nil
        @current_basket.delivery_address_2 = nil
        @current_basket.delivery_city = nil
        @current_basket.delivery_postcode = nil
        @current_basket.delivery_country = nil
        @current_basket.gift_wrap = nil
        @current_basket.gift_wrap_message = nil
        @current_basket.promo_code_id = nil
        @current_basket.shipping_option_id = nil
        @current_basket.save(false)
        redirect_to :controller => "baskets", :action => "set_user"    
      else 
        redirect_to root_path
      end
    else   
      redirect_to root_path
    end
  end  

end
