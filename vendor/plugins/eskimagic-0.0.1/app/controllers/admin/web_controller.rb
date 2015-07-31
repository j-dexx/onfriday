class Admin::WebController < Admin::AdminController

  def index
  	begin
    	if @current_administrator.features.length > 0
        feature = @current_administrator.features.select{|f| f.location == "Website Content" && !f.super_admin_only?}.sort_by{|f| f.position}.first
        redirect_to url_for(feature.path)
    	end
		rescue
		end
  end
  
  def recycle_bin
    @search = ExtraInfo.search(params[:search])
    @extra_infos = @search.paginate(:page => params[:page], :conditions => {:recycled => true})
  end

end
