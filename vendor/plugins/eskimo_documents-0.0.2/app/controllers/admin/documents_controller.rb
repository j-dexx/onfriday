class Admin::DocumentsController < Admin::AdminController

  def index
    @search = Document.newest.search(params[:search])
    @documents = @search.paginate(:page => params[:page])
  end
  
    def new
    @document = Document.new
  end  

  def create
    @document = Document.new(params[:document])
    if @document.save
      flash[:notice] = "Successfully created document."
      redirect_to admin_documents_path
    else
      render :action => 'new'
    end
  end  

  def edit
    @document = Document.find(params[:id])
  end  

  def update
    @document = Document.find(params[:id])
    if @document.update_attributes(params[:document])
      flash[:notice] = "Successfully updated document."
      redirect_to admin_documents_path
    else
      render :action => 'edit'
    end
  end  

  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    flash[:notice] = "Successfully destroyed document."
    redirect_to admin_documents_path
  end
  
  def update_stored_documents
    render :partial => "admin/form/stored_documents", :locals => {:object => params[:object], :document => params[:document]}
  end

end
