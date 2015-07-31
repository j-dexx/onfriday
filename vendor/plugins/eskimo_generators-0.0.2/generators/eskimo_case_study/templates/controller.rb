class <%= plural_class_name %>Controller < ApplicationController
  
  def index
  	if params[:tag]
  	  @title = "<%= plural_title %>: #{params[:tag]}"
      @search = <%= class_name %>.active.position.tagged_with(params[:tag].to_s, :on => "tags")
    else
      @title = "<%= plural_title %>"
      @search = <%= class_name %>.active.position
    end
    @<%= plural_name %> = @search.paginate(:page => params[:page], :per_page => 20)
  end  

  def show
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
    unless @<%= singular_name %>.active?
      redirect_to <%= plural_name %>_path
    end
  end
  
end
