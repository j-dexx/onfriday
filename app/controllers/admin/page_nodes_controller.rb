class Admin::PageNodesController < Admin::AdminController

  handles_images_for PageContent
	
	def index
    @roots = PageNode.unrecycled.position.roots
  end  
  
  def index_reorder
    @roots = PageNode.unrecycled.position.roots
  end  
  
  def index_advanced
    @roots = PageNode.unrecycled.position.roots
  end  
  
  def index_list
  	# set the default ordering
  	params[:search] ||= {}
  	params[:search][:order] ||= "descend_by_updated_at"
  	@search = PageNode.unrecycled.can_be_deleted_or_edited.search(params[:search])
  	@page_nodes = @search
  	if params[:filter_section] && !params[:filter_section].blank?
  		@page_nodes = @page_nodes.select{|x| x.ancestors.collect{|x| x.parent_id}.include?(params[:filter_section].to_i) || x.id == params[:filter_section]}
  	end
  	if params[:filter_display] == "true"
  		@page_nodes = @page_nodes.select{|x| x.display?}
  	elsif params[:filter_display] == "false"
  		@page_nodes = @page_nodes.select{|x| !x.display?}
  	end
  	if params[:search] && params[:search][:order] == "ascend_by_section"
  		@page_nodes = @page_nodes.sort_by{|x| x.sections_string}
  	elsif params[:search] && params[:search][:order] == "descend_by_section"
  		@page_nodes = @page_nodes.sort_by{|x| x.sections_string}.reverse
  	end
    @page_nodes = @page_nodes.paginate(:page => params[:page], :per_page => 50)
    @sections = [["Any", ""]] + (PageNode.can_have_children.active.select{|x| x.children.length > 0}.sort_by{|x| x.sections_name}.collect{|x| [x.sections_name, x.id]})
  end
  
  def index_list_advanced
  	# set the default ordering
  	params[:search] ||= {}
  	params[:search][:order] ||= "descend_by_updated_at"
  	@search = PageNode.unrecycled.can_be_deleted_or_edited.search(params[:search])
  	@page_nodes = @search
  	if params[:filter_section] && !params[:filter_section].blank?
  		@page_nodes = @page_nodes.select{|x| x.ancestors.collect{|x| x.parent_id}.include?(params[:filter_section].to_i) || x.id == params[:filter_section]}
  	end
  	if params[:filter_display] == "true"
  		@page_nodes = @page_nodes.select{|x| x.display?}
  	elsif params[:filter_display] == "false"
  		@page_nodes = @page_nodes.select{|x| !x.display?}
  	end
  	if params[:search] && params[:search][:order] == "ascend_by_section"
  		@page_nodes = @page_nodes.sort_by{|x| x.sections_string}
  	elsif params[:search] && params[:search][:order] == "descend_by_section"
  		@page_nodes = @page_nodes.sort_by{|x| x.sections_string}.reverse
  	end
    @page_nodes = @page_nodes.paginate(:page => params[:page], :per_page => 50)
    @sections = [["Any", ""]] + (PageNode.can_have_children.active.select{|x| x.children.length > 0}.sort_by{|x| x.sections_name}.collect{|x| [x.sections_name, x.id]})
  end

  def new
    @page_node = PageNode.new
  end  

  def create
    @page_node = PageNode.new(params[:page_node])
    if @page_node.save
    	page_contents = @page_node.page_contents.build(:active => true, :title => @page_node.name)
	  	page_contents.save
      flash[:notice] = "Step One Complete."
      redirect_to :action => "edit", :id => @page_node.id
    else
      render :action => 'new'
    end
  end  

  def edit
  	session[:page_node_list] = request.env["HTTP_REFERER"].to_s
    @page_node = PageNode.find(params[:id])
    if params[:content_id] && PageContent.exists?(params[:content_id])
    	@page_content = PageContent.find(params[:content_id])
    else
    	@page_content = @page_node.active_content
    end
  end  

  def update
    @page_node = PageNode.find(params[:id])
    if params[:content_id] && PageContent.exists?(params[:content_id])
    	@page_content = PageContent.find(params[:content_id])
    else
    	@page_content = @page_node.active_content
    end
    if @page_node.update_attributes(params[:page_node])
      flash[:notice] = "Successfully updated page node."
      if session[:page_node_list] && session[:page_node_list].include?("list")
      	redirect_to session[:page_node_list].to_s
      	session[:page_node_list] = nil
    	elsif session[:page_node_list]
      	redirect_to :controller => "admin/page_nodes", :action => "index", :page_node_id => @page_node.id
      	session[:page_node_list] = nil
      else
      	redirect_to admin_page_nodes_path
      end
    else
      render :action => 'edit'
    end
  end  

  def destroy
    @page_node = PageNode.find(params[:id])
    @page_content = PageContent.find(params[:content_id])
    if @page_node.page_contents.length > 1
    	@page_content.destroy
    	flash[:notice] = "Content Destroyed"
    	redirect_to :action => "edit", :id => @page_node.id
    else
    	@page_content.destroy
    	@page_node.destroy
    	flash[:notice] = "Page Destroyed"
    	redirect_to admin_page_nodes_path
    end
  end
  
  def sort
    set_parent_and_position(nil, params['sortable'])
    @roots = PageNode.position.roots
    respond_to do |request|
      request.js do
        render :update do |page|
          page[:tree].replace_html :partial => 'admin/page_nodes/tree', :locals => {:nodes => @roots}
        end
      end
    end
  end
  
  def order
    params[(params[:page_node_id].to_s)].each_with_index do |id, index|
    	PageNode.update_all(['position=?', index+1], ['id=?', id])
  	end
	  render :nothing => true
  end
  
  def set_parent_and_position(parent, sortable)
    sortable.each do |pos, hash|
      id = hash.delete("id")
      page = PageNode.find(id)
      page.update_attributes(:position => pos.to_i + 1, :parent_id => parent)
      set_parent_and_position(id, hash)
    end
  end
  
  def branch
  	page_node = PageNode.find(params[:page_node_id])
  	page_content = PageContent.find(params[:page_content_id])
  	new_content = page_content.clone
  	new_content.active = false
  	new_content.completed = false
  	new_content.published = false
  	new_content.save(false)
  	FileUtils.mkdir_p "public/assets/page_contents/#{new_content.id}"
  	FileUtils.cp_r "public/assets/page_contents/#{page_content.id}/.", "public/assets/page_contents/#{new_content.id}/"
  	flash[:notice] = "New Version Created"
  	redirect_to :controller => "admin/page_nodes", :action => "edit", :id => page_node.id, :content_id => new_content.id
  end
  
  def activate
  	page_content = PageContent.find(params[:content_id])
  	page_content.activate
  	flash[:notice] = "Content Activated"
  	redirect_to :controller => "admin/page_nodes", :action => "edit", :id => page_content.page_node.id
  end
  
  def toggle_display
  	page_node = PageNode.find(params[:id])
  	page_node.update_attribute(:display, !page_node.display?)
  	redirect_to :action => "edit", :id => params[:id], :content_id => params[:content_id]
	end
  
end
