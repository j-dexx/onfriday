class ProductStoriesController < ApplicationController
  def index
    @search  = ProductStory.active
    @product_stories = @search.paginate(:page => params[:page], :per_page => 20)
  end  

  def show
    @product_story = ProductStory.find(params[:id])
  end
end