# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

config.action_mailer.default_url_options = { :host => "192.168.0.122:6237" } 

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = true

# Do care if the mailer can't send
config.action_mailer.raise_delivery_errors = true

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "mail.eskimosoup.co.uk",
  :port => 25,
  :authentication => :plain,
  :user_name => "tasks@eskimosoup.co.uk",
  :password => "poipoip"
}

Paperclip.options[:command_path] = "/usr/local/bin/"
