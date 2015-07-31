# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  before_filter :check_for_site_maintenance
  before_filter :check_basket
  
  def initialize_basket
    Basket.tidy
    if session[:basket_id] && Basket.exists?(session[:basket_id])
      @current_basket = Basket.find(session[:basket_id])
    else
      @current_basket = Basket.create!
      session[:basket_id] = @current_basket.id
    end
    if current_user 
      @current_basket.update_attribute(:user_id, current_user.id)
      if current_user.credit > 0 && @current_basket.credit.nil?
        min = [current_user.credit, current_basket.total].min
        @current_basket.update_attribute(:credit, min)
      end
    end
  end
  
  def check_basket
    @current_basket = Basket.find(session[:basket_id]) if session[:basket_id] && Basket.exists?(session[:basket_id])
    if @current_basket
      if current_user
        @current_basket.update_attribute(:user_id, current_user.id)
      else
        @current_basket.update_attribute(:user_id, nil)
      end
    end
  end
  
  def check_for_site_maintenance
    if SiteSetting.find_by_name("Site Down For Maintenance").value == "true"
      unless current_administrator  
        unless params[:controller] == "web" && params[:action] == "site_down"
          redirect_to :controller => "web", :action => "site_down"
        end
      end
    end
    current_administrator
  end
  
	helper_method :current_administrator
	helper_method :current_user
	helper_method :current_basket  
	
	private
	
  def current_basket
    @current_basket
  end
    
  def current_user_session  
    return @current_user_session if defined?(@current_user_session)  
    @current_user_session = UserSession.find  
  end  
    
  def current_user  
    @current_user = current_user_session && current_user_session.record  
  end  

  def current_administrator_session
    return @current_administrator_session if defined?(@current_administrator_session)
    @current_administrator_session = AdministratorSession.find
  end
  
  def current_administrator
    return @current_administrator if defined?(@current_administrator)
    @current_administrator = current_administrator_session && current_administrator_session.record
  end

end
