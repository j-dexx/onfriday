class Admin::DonationPagesController < Admin::AdminController
  def index
    @search = DonationPage.unrecycled.search(params[:search])
    @donation_pages = @search.paginate(:page => params[:page], :per_page => 50)    
  end  

  def new
    @donation_page = DonationPage.new
  end  

  def create
    @donation_page = DonationPage.new(params[:donation_page])
    if @donation_page.save
      flash[:notice] = "Successfully created donation page."
      redirect_to admin_donation_pages_path
    else
      render :action => 'new'
    end
  end  

  def edit
    @donation_page = DonationPage.find(params[:id])
  end  

  def update
    @donation_page = DonationPage.find(params[:id])
    if @donation_page.update_attributes(params[:donation_page])
      flash[:notice] = "Successfully updated donation page."
      redirect_to admin_donation_pages_path
    else
      render :action => 'edit'
    end
  end  

  def order
    params[:draggable].each_with_index do |id, index|
      DonationPage.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end  

  def destroy
    @donation_page = DonationPage.find(params[:id])
    @donation_page.destroy
    flash[:notice] = "Successfully destroyed donation page."
    redirect_to admin_donation_pages_path
  end
end