class Admin::SiteSettingsController < Admin::AdminController
  def index
    if @current_administrator.super_admin?
      @search = SiteSetting.search(params[:search])
    else
      @search = SiteSetting.normal.search(params[:search])
    end
    @site_settings = @search.paginate(:page => params[:page])    
  end
  
  def new
    @site_setting = SiteSetting.new
  end  
  
  def create
    @site_setting = SiteSetting.new(params[:site_setting])
    if @site_setting.save
      flash[:notice] = "Successfully created site setting."
      redirect_to admin_site_settings_path
    else
      render :action => 'new'
    end
  end  
  
  def edit
    @site_setting = SiteSetting.find(params[:id])
    if @site_setting.super_admin_only && !@current_administrator.super_admin
      flash[:error] = "Permission Denied"
      redirect_to admin_path
    end
  end  
  
  def update
    @site_setting = SiteSetting.find(params[:id])
    if @site_setting.update_attributes(params[:site_setting])
      flash[:notice] = "Successfully updated site setting."
      redirect_to admin_site_settings_path
    else
      render :action => 'edit'
    end
  end 
  
  def destroy
    @site_setting = SiteSetting.find(params[:id])
    @site_setting.destroy
    flash[:notice] = "Successfully destroyed site setting."
    redirect_to admin_site_settings_path
  end
  
  def new_test_script
  	begin
	  	filename = "#{RAILS_ROOT}/bench_test.sh"
	  	if File.exists?(filename)
	  		File.delete(filename)
			end
			file = File.new(filename, "w+")
			for node in PageNode.active
				file.puts("echo 'Testing #{node.name} (#{url_for(node.path)})...'")
				file.puts("sleep 2")
				file.puts("bench -u #{url_for(node.path)} -c 2 -r 10")
				file.puts("sleep 3")
			end
			
    	model_names = PageNode.models.collect{|pn| pn.model.pluralize.humanize}
    	models = PageNode.models.collect{|pn| pn.model.camelcase.constantize}
    	for model in models
    		for object in model.send("active")
    			file.puts("echo 'Testing #{object.class.name} #{object.id} (#{url_for(object)})...'")
				  file.puts("sleep 2")
				  file.puts("bench -u #{url_for(object)} -c 2 -r 10")
				  file.puts("sleep 3")
    		end
  		end
			
			file.close
			FileUtils.chmod 0777, filename
			flash[:notice] = "Test script created"
			redirect_to admin_site_settings_path
		rescue Exception => e
			flash[:error] = "Error creating test script:<br />#{e.to_yaml}"
			redirect_to admin_site_settings_path
		end
	end
	
	def new_site_map
		begin
			filename = "#{RAILS_ROOT}/public/sitemap.xml"
	  	if File.exists?(filename)
	  		File.delete(filename)
			end
			file = File.new(filename, "w+")
			file.puts '<?xml version="1.0" encoding="UTF-8"?>'
			file.puts '<urlset xmlns="http://www.google.com/schemas/sitemap/0.84">'
			for node in PageNode.active
				file.puts '<url>'
				file.puts "<loc>#{url_for(node.path)}</loc>"
				file.puts "<lastmod>#{Time.now.strftime('%Y-%m-%d')}</lastmod>"
				file.puts '<changefreq>daily</changefreq>'
				file.puts '<priority>0.5</priority>'
				file.puts '</url>'
			end
			file.puts '</urlset>'
			file.close
			FileUtils.chmod 0777, filename
			flash[:notice] = "Site map created"
			redirect_to admin_site_settings_path
		rescue Exception => e
			flash[:error] = "Error creating site map:<br />#{e.to_yaml}"
			redirect_to admin_site_settings_path
		end
	end
	
end
