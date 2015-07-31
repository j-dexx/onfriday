class SpotlightsController < ApplicationController
  def index
    @spotlight = Spotlight.highlighted.last
  end
  
  def show
    @spotlight = Spotlight.find(params[:id])
    render :index
  end
end
