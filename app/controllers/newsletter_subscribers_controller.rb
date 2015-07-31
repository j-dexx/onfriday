class NewsletterSubscribersController < ApplicationController
  
  def index
    redirect_to :action => "new"
  end

  def new
    @newsletter_subscriber = NewsletterSubscriber.new()
  end
  
  def create
    @newsletter_subscriber = NewsletterSubscriber.new(params[:newsletter_subscriber])
    if @newsletter_subscriber.save 
      flash[:notice] = "You have subscribed to the newsletter."
      redirect_to :back
    else
      flash[:error] = "There was a problem with your newsletter subscription, the email could be invalid or your email address may already be registered."
      redirect_to :back 
    end
  end
  
  def unsubscribe
    if request.post?
      newsletter_subscriber = NewsletterSubscriber.find_by_email(params[:email])
      if newsletter_subscriber
        newsletter_subscriber.destroy
        flash[:notice] = "You have been unsubscribed"      
      else
        flash[:error] = "Cannot find email address"
      end
      render :action => "unsubscribe"
    end
  end
  
end
