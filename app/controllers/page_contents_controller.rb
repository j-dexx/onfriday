class PageContentsController < ApplicationController
  
  def show
    page_content = PageContent.find(params[:id])
    redirect_to page_content.page_node
  end

end