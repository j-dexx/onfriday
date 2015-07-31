class Admin::ExtraInfosController < Admin::AdminController

  def index 
  	require 'find'

		models = []
		Find.find("#{RAILS_ROOT}/app/models") do |path|
	    if FileTest.directory?(path)
	      #skip, this is a folder
	      next
	    else
	      #strip filename to just model_name
	      filename = File.basename(path, '.rb')
	      models << filename.camelize.constantize
	    end
		end
		
		search = []
		
    for klass in models
    	begin
    		search += klass.send("recycled")
    	rescue
    	end
    end  
    
    @extra_infos = search.paginate(:page => params[:page])  
    
  end
  
  def destroy
    item = params[:class].constantize.find(params[:id].to_i)
    begin
    	item.destroy
    	flash[:notice] = "Successfully destroyed object."
    rescue
    	flash[:error] = "Could not destroyed object - please contact technical support."
    end
    redirect_to admin_recycle_bin_path
  end
  
  def destroy_all
    require 'find'

		models = []
		Find.find("#{RAILS_ROOT}/app/models") do |path|
	    if FileTest.directory?(path)
	      #skip, this is a folder
	      next
	    else
	      #strip filename to just model_name
	      filename = File.basename(path, '.rb')
	      models << filename.camelize.constantize
	    end
		end
		
		search = []
		
    for klass in models
    	begin
    		search += klass.send("recycled")
    	rescue
    	end
    end
    
    for item in search
    	begin
    		item.destroy	
    	rescue
    	end
    end
    flash[:notice] = "Attempted to destroy all objects in recycle bin."
    redirect_to admin_recycle_bin_path
  end
  
  def restore
  	item = params[:class].constantize.find(params[:id].to_i)
    begin
    	item.restore
    	flash[:notice] = "Successfully restored object."
    rescue
    	flash[:error] = "Could not restore object - please contact technical support."
    end
    redirect_to admin_recycle_bin_path
  end
  
  def restore_all
    require 'find'

		models = []
		Find.find("#{RAILS_ROOT}/app/models") do |path|
	    if FileTest.directory?(path)
	      #skip, this is a folder
	      next
	    else
	      #strip filename to just model_name
	      filename = File.basename(path, '.rb')
	      models << filename.camelize.constantize
	    end
		end
		
		search = []
		
    for klass in models
    	begin
    		search += klass.send("recycled")
    	rescue
    	end
    end
    
    for item in search
    	begin
    		item.restore
    	rescue
    	end
    end
    flash[:notice] = "Attempted to restore all objects."
    redirect_to admin_recycle_bin_path
  end
  
end
