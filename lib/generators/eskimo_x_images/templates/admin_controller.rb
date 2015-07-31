class Admin::<%= class_name %>ImagesController < Admin::AdminController
  
  handles_images_for <%= class_name %>Image

  def index
    if params[:<%= singular_name %>_id]
      session[:<%= singular_name %>_id] = params[:<%= singular_name %>_id]
    end
    @<%= singular_name %> = <%= class_name %>.find(session[:<%= singular_name %>_id])
    @search = <%= class_name %>Image.unrecycled.position.<%= singular_name %>_id(@<%= singular_name %>.id).search(params[:search])
    @<%= singular_name %>_images = @search.paginate(:page => params[:page], :per_page => 50)    
  end  

  def new
    @<%= singular_name %> = <%= class_name %>.find(session[:<%= singular_name %>_id])
    @<%= singular_name %>_image = <%= class_name %>Image.new(:<%= singular_name %>_id => @<%= singular_name %>.id)
  end  

  def create
    @<%= singular_name %>_image = <%= class_name %>Image.new(params[:<%= singular_name %>_image])
    if @<%= singular_name %>_image.save
      flash[:notice] = "Successfully created <%= human_singular_name %> image."
      redirect_to admin_<%= singular_name %>_images_path(:<%= singular_name %>_id => @<%= singular_name %>_image.<%= singular_name %>.id)
    else
      render :action => 'new'
    end
  end  

  def edit
    @<%= singular_name %>_image = <%= class_name %>Image.find(params[:id])
  end  

  def update
    @<%= singular_name %>_image = <%= class_name %>Image.find(params[:id])
    @<%= singular_name %> = <%= class_name %>.find(session[:<%= singular_name %>_id])
    if @<%= singular_name %>_image.update_attributes(params[:<%= singular_name %>_image])
      flash[:notice] = "Successfully updated <%= human_singular_name %> image."
      redirect_to admin_<%= singular_name %>_images_path(:<%= singular_name %>_image => @<%= singular_name %>.id)
    else
      render :action => 'edit'
    end
  end  

  def order
    params[:draggable].each_with_index do |id, index|
      <%= class_name %>Image.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end  

  def destroy
    @<%= singular_name %>_image = <%= class_name %>Image.find(params[:id])
    @<%= singular_name %>_image.destroy
    flash[:notice] = "Successfully destroyed <%= human_singular_name %> image."
    redirect_to admin_<%= singular_name %>_images_path
  end
  
end
