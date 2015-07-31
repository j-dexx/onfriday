class <%= plural_class_name %>Controller < ApplicationController
  
  def index
  	params[:page] ||= 1
  	if params[:tag]
  	  @title = "<%= plural_title %>: #{params[:tag]}"
      @search = <%= class_name %>.active.tagged_with(params[:tag].to_s, :on => "tags")
    elsif params[:year] && params[:month]
      @title = "<%= plural_title %>: #{Date::MONTHNAMES[params[:month].to_i]} #{params[:year]}"
      @search = <%= class_name %>.active.start_year(params[:year]).start_month(params[:month])
    elsif params[:year]
      @title = "<%= plural_title %>: #{params[:year]}"
    	@search = <%= class_name %>.active.start_year(params[:year])
    else
      @title = "<%= plural_title %>"
      @search = <%= class_name %>.active
    end
    @<%= plural_name %> = @search.upcoming.paginate(:page => params[:page], :per_page => 20)
  end  

  def show
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
    unless @<%= singular_name %>.active?
      redirect_to <%= plural_name %>_path
    end
  end
  
end
