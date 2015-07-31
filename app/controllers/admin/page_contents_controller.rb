class Admin::PageContentsController < Admin::AdminController
  def index
    @search = PageContent.search(params[:search])
    @page_contents = @search.paginate(:page => params[:page], :per_page => 50)    
  end  

  def new
    @page_content = PageContent.new
  end  

  def create
    @page_content = PageContent.new(params[:page_content])
    if @page_content.save
      flash[:notice] = "Successfully created page content."
      redirect_to admin_page_contents_path
    else
      render :action => 'new'
    end
  end  

  def edit
    @page_content = PageContent.find(params[:id])
  end  

  def update
    @page_content = PageContent.find(params[:id])
    if @page_content.update_attributes(params[:page_content])
      flash[:notice] = "Successfully updated page content."
      redirect_to admin_page_contents_path
    else
      render :action => 'edit'
    end
  end  

  def destroy
    @page_content = PageContent.find(params[:id])
    @page_content.destroy
    flash[:notice] = "Successfully destroyed page content."
    redirect_to admin_page_contents_path
  end
end