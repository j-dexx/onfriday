  def index
    @search = <%= class_name %>.unrecycled.search(params[:search])
    @<%= plural_name %> = @search.paginate(:page => params[:page], :per_page => 50)    
  end