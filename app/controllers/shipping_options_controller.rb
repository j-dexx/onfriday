class ShippingOptionsController < ApplicationController

  protect_from_forgery :except => [:index, :index_billing]
  
  def index
    @shipping_options = ShippingOption.find_by_country(params[:country])
    if params[:country] == 'US'
      @states = Country.find_country_by_name('united states').states.collect{|x| [x.second["name"], x.first]}
      @state = nil
      @state = current_basket.delivery_state if current_basket && current_basket.delivery_state 
      render :update do |page|
        page[:delivery_state_container].replace_html(:partial => "shipping_options/index_delivery")
        page[:shipping_options].replace_html :partial => "shipping_options/index"
      end
    else
      render :update do |page|
        page[:delivery_state_container].replace_html("")
        page[:shipping_options].replace_html :partial => "shipping_options/index"
      end
    end
  end
  
  def index_billing
    if params[:country] == 'US'
      @states = Country.find_country_by_name('united states').states.collect{|x| [x.second["name"], x.first]}
      @state = nil
      @state = current_basket.billing_state if current_basket && current_basket.billing_state
      render :update do |page|
        page[:billing_state_container].replace_html(:partial => "shipping_options/index_billing")
      end
    else
      render :update do |page|
        page[:billing_state_container].replace_html("")
      end
    end
    
  end
  
end
