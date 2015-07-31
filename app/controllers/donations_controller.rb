class DonationsController < ApplicationController
  
  def index
    @donation_page = DonationPage.find(params[:donation_page_id])
  end
  
end
