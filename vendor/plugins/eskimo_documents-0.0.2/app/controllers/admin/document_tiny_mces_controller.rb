class Admin::DocumentTinyMcesController < Admin::AdminController

  layout "admin_popup"

  def index
    params[:link_text] ||= session[:document_text] if session[:document_text]
    session[:document_text] = params[:link_text].gsub('"', '\"')
    @search = Document.newest.search(params[:search])
    @documents = @search.paginate(:page => params[:page])
  end
  
  def show
    @document = Document.find(params[:id])
  end
  
  def insert
    @document = Document.find(params[:id])
  end
  
  def new
    @document = Document.new
  end  

  def create
    @document = Document.new(params[:document])
    if @document.save
      flash[:notice] = "Successfully created document."
      redirect_to admin_document_tiny_mces_path
    else
      render :action => 'new'
    end
  end  

  def update
    @document = Document.find(params[:id])
    if @document.update_attributes(params[:document])
      flash[:notice] = "Successfully updated document."
      redirect_to admin_document_tiny_mces_path
    else
      render :action => 'edit'
    end
  end  

  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    flash[:notice] = "Successfully destroyed document."
    redirect_to admin_document_tiny_mces_path
  end

end
