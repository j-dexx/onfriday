class Admin::RedirectsController < Admin::AdminController
  def index
    @redirects = Redirect.read_file
  end
  
  def create
    @redirects = []
    params[:redirects].each_value do |v|
      @redirects << [v["from"], v["to"]]
    end
    
    begin
      Redirect.write_file request.env["HTTP_HOST"], @redirects
    rescue RuntimeError => e
      flash[:notice] = e.message
      redirect_to params.merge(:action => "index")
    else
      redirect_to :action => "index"
    end
  end
end
