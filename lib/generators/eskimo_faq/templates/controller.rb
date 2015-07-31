class <%= plural_class_name %>Controller < ApplicationController
  
  def index
    if params[:tag]
      @search = <%= class_name %>.active.position.tagged_with(params[:tag], :on => "tags")
    else
    	@search = <%= class_name %>.active.position
    end  	
    @<%= plural_name %> = @search.paginate(:page => params[:page], :per_page => 20)
  end  
  
end
