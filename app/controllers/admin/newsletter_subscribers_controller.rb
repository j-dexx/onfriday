class Admin::NewsletterSubscribersController < Admin::AdminController
  def index
    @search = NewsletterSubscriber.unrecycled.search(params[:search])
    @newsletter_subscribers = @search.paginate(:page => params[:page], :per_page => 50)    
  end  
  
  def list
    @newsletter_subscribers = NewsletterSubscriber.active
  end

  def new
    @newsletter_subscriber = NewsletterSubscriber.new
  end  

  def create
    @newsletter_subscriber = NewsletterSubscriber.new(params[:newsletter_subscriber])
    if @newsletter_subscriber.save
      flash[:notice] = "Successfully created newsletter subscriber."
      redirect_to admin_newsletter_subscribers_path
    else
      render :action => 'new'
    end
  end  

  def edit
    @newsletter_subscriber = NewsletterSubscriber.find(params[:id])
  end  

  def update
    @newsletter_subscriber = NewsletterSubscriber.find(params[:id])
    if @newsletter_subscriber.update_attributes(params[:newsletter_subscriber])
      flash[:notice] = "Successfully updated newsletter subscriber."
      redirect_to admin_newsletter_subscribers_path
    else
      render :action => 'edit'
    end
  end  

  def order
    params[:draggable].each_with_index do |id, index|
      NewsletterSubscriber.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end  

  def destroy
    @newsletter_subscriber = NewsletterSubscriber.find(params[:id])
    @newsletter_subscriber.destroy
    flash[:notice] = "Successfully destroyed newsletter subscriber."
    redirect_to admin_newsletter_subscribers_path
  end
end
