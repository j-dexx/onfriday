class Admin::DonationsController < Admin::AdminController
  def index
    @search = Donation.unrecycled.search(params[:search])
    @donations = @search.paginate(:page => params[:page], :per_page => 50)    
  end  

  def new
    @donation = Donation.new
  end  

  def create
    @donation = Donation.new(params[:donation])
    if @donation.save
      flash[:notice] = "Successfully created donation."
      redirect_to admin_donations_path
    else
      render :action => 'new'
    end
  end  

  def edit
    @donation = Donation.find(params[:id])
  end  

  def update
    @donation = Donation.find(params[:id])
    if @donation.update_attributes(params[:donation])
      flash[:notice] = "Successfully updated donation."
      redirect_to admin_donations_path
    else
      render :action => 'edit'
    end
  end  

  def order
    params[:draggable].each_with_index do |id, index|
      Donation.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end  

  def destroy
    @donation = Donation.find(params[:id])
    @donation.destroy
    flash[:notice] = "Successfully destroyed donation."
    redirect_to admin_donations_path
  end
end