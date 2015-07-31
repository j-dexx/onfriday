class DonationPagesController < ApplicationController
  
  include UserSessionsHelper
  before_filter :load_product, :except => [:index, :show, :convert, :email, :send_email]
  before_filter :validate_user, :except => [:show, :new]
  before_filter :validate_user_with_redirect, :only => :new
  
  
  def validate_user_with_redirect
    unless current_user
      flash[:error] = "You must login to view this content"
      session[:target] = new_product_donation_page_path(@product)
      redirect_to new_user_session_path
      return
    end
  end
  
  def load_product
    @product = Product.find(params[:product_id])
  end

  def show
    @donation_page = DonationPage.find(params[:id])
    @product_image = ProductImage.active.product_id_equals(@donation_page.product.id).first
    @product = @donation_page.product
    @donations = @donation_page.donations.sort_by{|x| x.created_at}
  end
  
  def new
    default_summary = "Welcome to my very own onfriday Gift Wishlist page! This is the bag I have chosen as my gift. When you're ready to make a contribution please click the button on the right of this page. You'll also be able to leave a message for me if you'd like too! Thank you for making my wish come true!"
    @donation_page = DonationPage.new(:target_date => Date.today + 14, :summary => default_summary)
  end  

  def create
    @donation_page = DonationPage.new(params[:donation_page])
    @donation_page.user = current_user
    @donation_page.product = @product
    if @donation_page.save
      flash[:notice] = "Successfully created donation page."
      redirect_to donation_pages_path
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
      redirect_to donation_pages_path
    else
      render :action => 'edit'
    end
  end
  
  def index
    @donation_pages = DonationPage.active.user_id_equals(current_user.id)
    @closed_donation_pages = DonationPage.inactive.user_id_equals(current_user.id)
  end
  
  def convert
    @donation_page = DonationPage.find(params[:id])
    if request.post?
      if @donation_page.display == false
        flash[:error] = "This donation page has already been converted."
        redirect_to :action => "index"
      else
        @donation_page.update_attribute(:display, false)
        current_user.update_attribute(:credit, current_user.credit + @donation_page.total)
        flash[:notice] = "Donations converted."
        redirect_to credit_user_path(:current)
      end
    end
  end
  
  def email
    params[:email] ||= {}
    params[:email][:content] ||= "Hello\r\rI have a special occasion coming up soon and I was wondering whether you would like to make a contribution to a Gift Wishlist I have set up with onfriday. They source and showcase a great range of bags that have either been upcycled or fairly traded, so the gift I have chosen is helping to make this world a fairer, greener one!\r\rBy clicking the link below you will go straight to my secure Giftwish page on the onfriday website where you can have a look at the bag I have chosen, make a payment through their secure Sagepay payment gateway and leave a comment for me too! \r\rThank you very much!"
    params[:email][:subject] ||= DonationPage.find(params[:id]).name
  end 
  
  def send_email
   donation_page = DonationPage.find(params[:id])
    # bad
    if params[:email][:content].blank?
      flash.now[:error] = 'Please enter content for your email.'
      render :action => "email"
    elsif params[:email][:recipients].blank?
      flash.now[:error] = 'Please enter at least one email address.'
      render :action => "email" 
    elsif params[:email][:subject].blank?
      flash.now[:error] = 'Please enter a subject.'
      render :action => "email"     
    else
#      begin
        Mailer.deliver_donation(params[:email][:recipients], params[:email][:subject], params[:email][:content], donation_page)
        flash[:notice] = "Email sent"
        redirect_to donation_pages_path
#      rescue
#        flash.now[:error] = 'One or more recipient does not seem to be valid.'
#        render :action => "email"     
#      end
    end
  end
end
