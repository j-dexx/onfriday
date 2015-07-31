class PageNodesController < ApplicationController

  include PageContentsHelper
  
  def show
    @page_node = PageNode.find(params[:id])
    
    unless @page_node.display? || params[:preview]
      redirect_to "/404.html"
      return
    end
    
    # try and call the helper method matching the layout
    begin
      send(@page_node.layout)
    rescue Exception => e
      #logger.info e.to_yaml
    end
    
    if @page_node.controller? && @page_node.action?
    	redirect_to url_for(:controller => @page_node.controller, :action => @page_node.action)
    	return
    elsif @page_node.controller?
    	redirect_to url_for(@page_node.controller)
    	return
    end
  end

end
