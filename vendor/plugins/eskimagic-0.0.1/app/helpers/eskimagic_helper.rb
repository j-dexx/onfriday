module EskimagicHelper
  
  ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  	 "<span class=\"field_with_errors\">#{html_tag}</span>"  	
  end
  
  def metadata(meta_description, meta_tags)
    content_for :head do
      ret = ""
      ret += "<meta name=\"description\" content=\"#{meta_description}\" />"
      ret += "<meta name=\"keywords\" content=\"#{meta_tags}\" />"
      ret
    end
  end
  
  def title(page_title)
    @content_for_title = page_title.to_s
  end
  
  def hide_left
  	@hide_left = true
  end
  def hide_left?
  	@hide_left
  end
  
  def hide_right
    @hide_right = true
  end
  def hide_right?
    @hide_right
  end
  
  def hide_title
  	@hide_title = true
  end
  def hide_title?
  	@hide_title
  end
      
  def hide_flash
    @hide_flash = true
  end
  def hide_flash?
    @hide_flash
  end
  
  def hide_right_nav
    @hide_right_nav = true
  end
  def hide_right_nav?
    @hide_right_nav
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  
def scale_image_tag(picture_id, options={})
    defaults = {:width => nil, :height => nil}
    options = defaults.merge(options)
    if Picture.exists? picture_id
    	picture = Picture.find(picture_id)
      image_tag(picture.url(options), {:alt => picture.alt}.merge(options))
    end
  end
  
  def thumbnail_image_tag(picture_id, thumbnail, options={})
    defaults = {:width => nil, :height => nil} 
    options = defaults.merge(options)
    if thumbnail && thumbnail != '' && Picture.exists?(picture_id)
    	picture = Picture.find(picture_id)
    	ret = image_tag(thumbnail.split("/public")[1], {:alt => picture.alt}.merge(options))
    else
      ret = scale_image_tag(picture_id, options).to_s
    end
    ret
  end
  
  def tag_links(tags, list_action=nil)
    tag_link_array = []
    for tag in tags
      if list_action
        tag_link_array << link_to(tag.name, {:action => list_action, :tag => tag.name}, :class => "tag")
      else
        tag_link_array << link_to(tag.name, {:tag => tag.name}, :class => "tag")
      end
    end
    tag_link_array.join(" | ")
  end
  
  def object_url(object_class, object_id=nil)
    if object_class && object_class.strip != ""
      if object_id == nil
        url_for(object_class.to_sym)
      else
        if object_class.singularize.camelcase.constantize.exists?(object_id)
          url_for(object_class.singularize.camelcase.constantize.find(object_id))
        end
      end
    end
  end
  
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end

end
