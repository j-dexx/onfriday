class ArticlesController < ApplicationController
  def index
    @title = "What's Happening"
  	if params[:tag]
  	  @title += " - #{params[:tag]}"
      @search = Article.active.tagged_with(params[:tag].to_s, :on => "tags")
    elsif params[:year] && params[:month]
      @title += " - #{Date::MONTHNAMES[params[:month].to_i]} #{params[:year]}"
      @search = Article.active.year(params[:year]).month(params[:month])
    elsif params[:year]
      @title += " - #{params[:year]}"
    	@search = Article.active.year(params[:year])
    else
      @search = Article.active
    end
    @articles = @search.paginate(:page => params[:page], :per_page => 20)
  end  

  def show
    @article = Article.find(params[:id])
  end
end
