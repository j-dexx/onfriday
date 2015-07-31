class AdminMailer < ActionMailer::Base
  
  def contact(name, email, message)
    unless name && name != ""
      name = "A User"
    end
      
    recipients    SiteSetting.like("email").first.value
    from          SiteSetting.like("email").first.value
    reply_to      email
    subject       "#{name} has filled in the contact us form"
    sent_on       Time.now
    body          (:name => name, :email => email, :message => message)
    content_type  "text/html"
  end
  
  def exception_snapshot(exception, clean_backtrace, data, params, env)
  	recipients    SiteSetting.like("site maintainer").first.value
    from          SiteSetting.like("email").first.value
    subject       "Exception Reported #{SiteSetting.like("site name").first.value} - #{env["HTTP_FROM"]}"
    sent_on       Time.now
    body          (:exception => exception, 
    								:clean_backtrace => clean_backtrace, 
    								:data => data,
    								:params => params,
    								:env => env)
    content_type  "text/html"
  end

   def password_reset_instructions(administrator)
    subject      "Password Reset Instructions"
    from         SiteSetting.like("email").first.value
    recipients   administrator.email
    content_type "text/html"
    sent_on      Time.now
    body         :edit_admin_password_reset_url => edit_admin_password_reset_url(administrator.perishable_token)
  end

  
end
