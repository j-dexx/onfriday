class FaqsController < ApplicationController
  
  def index
    if params[:tag]
      @search = Faq.active.position.tagged_with(params[:tag], :on => "tags")
    else
    	@search = Faq.active.position
    end  	
    @faqs = @search.paginate(:page => params[:page], :per_page => 20)
  end  
  
end
