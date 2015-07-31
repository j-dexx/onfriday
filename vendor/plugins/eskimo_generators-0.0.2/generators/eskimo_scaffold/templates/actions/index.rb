  def index
    @search  = <%= class_name %>.active
    @<%= plural_name %> = @search.paginate(:page => params[:page], :per_page => 20)
  end