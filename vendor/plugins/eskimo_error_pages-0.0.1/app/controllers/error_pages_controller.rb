class ErrorPagesController < ApplicationController

  unloadable
  
  def e404
    if File.exists?(File.join(RAILS_ROOT, "app", "views", "error_pages", "e404.html.erb"))
      # render page
    else
      render :layout => "application", :text => "<h1>The page you were looking for doesn't exist (404)</h1>"
    end
  end
  
  def e500
    if File.exists?(File.join(RAILS_ROOT, "app", "views", "error_pages", "e500.html.erb"))
      # render page
    else
      render :layout => "application", :text => "<h1>We're sorry, but something went wrong (500)</h1>"
    end
  end

end
