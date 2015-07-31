class Admin::<%= plural_class_name %>Controller < Admin::AdminController
  
  handles_images_for <%= class_name %>

  def index
    @search = <%= class_name %>.unrecycled.position.search(params[:search])
    @<%= plural_name %> = @search.paginate(:page => params[:page], :per_page => 50)    
  end  

  def new
    @<%= singular_name %> = <%= class_name %>.new
  end  

  def create
    @<%= singular_name %> = <%= class_name %>.new(params[:<%= singular_name %>])
    if @<%= singular_name %>.save
      flash[:notice] = "Successfully created <%= human_singular_name %>."
      redirect_to admin_<%= plural_name %>_path
    else
      render :action => 'new'
    end
  end  

  def edit
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
  end  

  def update
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
    if @<%= singular_name %>.update_attributes(params[:<%= singular_name %>])
      flash[:notice] = "Successfully updated <%= human_singular_name %>."
      redirect_to admin_<%= plural_name %>_path
    else
      render :action => 'edit'
    end
  end  

  def order
    params[:draggable].each_with_index do |id, index|
      <%= class_name %>.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end  

  def destroy
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
    @<%= singular_name %>.destroy
    flash[:notice] = "Successfully destroyed <%= human_singular_name %>."
    redirect_to admin_<%= plural_name %>_path
  end
  
end
