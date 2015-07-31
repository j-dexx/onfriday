class Admin::FaqsController < Admin::AdminController
  
  handles_images_for Faq
  handles_documents_for Faq

  def index
    @search = Faq.unrecycled.position.search(params[:search])
    @faqs = @search.paginate(:page => params[:page], :per_page => 50)    
  end  

  def new
    @faq = Faq.new
  end  

  def create
    @faq = Faq.new(params[:faq])
    if @faq.save
      flash[:notice] = "Successfully created Faq."
      redirect_to admin_faqs_path
    else
      render :action => 'new'
    end
  end  

  def edit
    @faq = Faq.find(params[:id])
  end  

  def update
    @faq = Faq.find(params[:id])
    if @faq.update_attributes(params[:faq])
      flash[:notice] = "Successfully updated Faq."
      redirect_to admin_faqs_path
    else
      render :action => 'edit'
    end
  end  

  def order
    params[:draggable].each_with_index do |id, index|
      Faq.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end  

  def destroy
    @faq = Faq.find(params[:id])
    @faq.destroy
    flash[:notice] = "Successfully destroyed Faq."
    redirect_to admin_faqs_path
  end
  
end
