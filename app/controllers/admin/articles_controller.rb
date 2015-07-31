class Admin::ArticlesController < Admin::AdminController

  handles_images_for Article

  def index
    @search = Article.unrecycled.search(params[:search])
    @articles = @search.paginate(:page => params[:page], :per_page => 50)    
  end  

  def new
    @article = Article.new
  end  

  def create
    @article = Article.new(params[:article])
    if @article.save
      flash[:notice] = "Successfully created article."
      if Article.image_changes?(params[:article])
        redirect_to :action => "index_images", :id => @article.id
      else
        redirect_to admin_articles_path
      end
    else
      render :action => 'new'
    end
  end  

  def edit
    @article = Article.find(params[:id])
  end  

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(params[:article])
      flash[:notice] = "Successfully updated article."
      if Article.image_changes?(params[:article])
        redirect_to :action => "index_images", :id => @article.id
      else
        redirect_to admin_articles_path
      end
    else
      render :action => 'edit'
    end
  end  

  def order
    params[:draggable].each_with_index do |id, index|
      Article.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end  

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    flash[:notice] = "Successfully destroyed article."
    redirect_to admin_articles_path
  end
end
