class Admin::ProductStoriesController < Admin::AdminController
  def index
    @search = ProductStory.unrecycled.search(params[:search])
    @product_stories = @search.paginate(:page => params[:page], :per_page => 50)    
  end  

  def new
    @product_story = ProductStory.new
  end  

  def create
    @product_story = ProductStory.new(params[:product_story])
    if @product_story.save
      flash[:notice] = "Successfully created product story."
      redirect_to admin_product_stories_path
    else
      render :action => 'new'
    end
  end  

  def edit
    @product_story = ProductStory.find(params[:id])
  end  

  def update
    params[:product_story][:product_ids] ||= []
    @product_story = ProductStory.find(params[:id])
    if @product_story.update_attributes(params[:product_story])
      flash[:notice] = "Successfully updated product story."
      redirect_to admin_product_stories_path
    else
      render :action => 'edit'
    end
  end  

  def order
    params[:draggable].each_with_index do |id, index|
      ProductStory.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end  

  def destroy
    @product_story = ProductStory.find(params[:id])
    @product_story.destroy
    flash[:notice] = "Successfully destroyed product story."
    redirect_to admin_product_stories_path
  end
end
