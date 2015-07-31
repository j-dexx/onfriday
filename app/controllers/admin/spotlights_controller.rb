class Admin::SpotlightsController < Admin::AdminController

  handles_images_for Spotlight

  def index
    @search = Spotlight.unrecycled.search(params[:search])
    @spotlights = @search.paginate(:page => params[:page], :per_page => 50)    
  end  

  def index_update
    params[:ids] ||= []
    @search = Spotlight.unrecycled.search(params[:search])
    @spotlights = @search.paginate(:page => params[:page], :per_page => 50) 
    for spotlight in @spotlights
      if params[:ids].include? spotlight.id.to_s
        spotlight.highlight = true
      else
        spotlight.highlight = false
      end
      spotlight.save
    end
    redirect_to :action => :index, :search => params[:search], :page => params[:page]
  end
  
  def new
    @spotlight = Spotlight.new
  end  

  def create
    @spotlight = Spotlight.new(params[:spotlight])
    if @spotlight.save
      flash[:notice] = "Successfully created spotlight."
      redirect_to admin_spotlights_path
    else
      render :action => 'new'
    end
  end  

  def edit
    @spotlight = Spotlight.find(params[:id])
  end  

  def update
    @spotlight = Spotlight.find(params[:id])
    if @spotlight.update_attributes(params[:spotlight])
      flash[:notice] = "Successfully updated spotlight."
      redirect_to admin_spotlights_path
    else
      render :action => 'edit'
    end
  end  

  def order
    params[:draggable].each_with_index do |id, index|
      Spotlight.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end  

  def destroy
    @spotlight = Spotlight.find(params[:id])
    @spotlight.destroy
    flash[:notice] = "Successfully destroyed spotlight."
    redirect_to admin_spotlights_path
  end
end
