class Admin::LinkTinyMcesController < Admin::AdminController

  layout "admin_popup"
  
  def index
    params[:link_text] ||= session[:link_text] if session[:link_text]
    session[:link_text] = params[:link_text].gsub('"', '\"')
  end
  
  def new_internal_link
  	@page_nodes = PageNode.all
  	@model_names = PageNode.models.collect{|pn| pn.model.underscore.humanize.pluralize}
  	@models = PageNode.models.collect{|pn| pn.model.singularize.camelcase.constantize}
  	@object_list = []
  	for model in @models
  		group = [model.to_s.pluralize.humanize,[]]
  		for object in model.send("all")
  			group[1] << [object.name, "#{object.id}!#!#{model}"]
  		end
  		@object_list << group
		end
  end

  def new_external_link
  end
  
  def new_email_link
  end

  def insert
    if params[:link_type] == "external"
      @tag_text = "http://" + params[:url]
    elsif params[:link_type] == "email"
      @tag_text = "mailto:" + params[:url]
    elsif params[:link_type] == "page"
      @tag_text = url_for(PageNode.find(params[:page_node_id]))
    elsif params[:link_type] == "object"
      object_name = params[:object_class_id].split("!#!").last
      object_id = params[:object_class_id].split("!#!").first
      @tag_text = url_for(object_name.constantize.send("find", object_id))
    elsif params[:link_type] == "remove"
      @tag_text = ""
    end
  end
end
