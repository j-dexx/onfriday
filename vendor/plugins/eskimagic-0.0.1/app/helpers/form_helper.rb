module FormHelper
  
  def self.included(base)
    ActionView::Base.class_eval do
      include FormTagMethods
    end
    ActionView::Helpers::FormBuilder.instance_eval do 
      include FormBuilderMethods
    end
  end
  
  module FormTagMethods

		def check_box(object_name, method, options = {}, checked_value = "1", unchecked_value = "0") 
			options = {:class => "checkbox"}.merge(options)
			super(object_name, method, options, checked_value, unchecked_value) 
		end
  	
  	def submit_tag(value="Submit", options={}) 
  		options = {:class => "submit"}.merge(options)
  		super(value, options)
  	end
    
    def helpful_label_tag(name, text, title, attributes={})
      label_tag(name, text, attributes.merge(:class => "help_icon", :onmouseover => "ddrivetip('#{title}')", :onmouseout => "hideddrivetip()"))
    end
    
    def tree_select(nodes, name, selected=nil, options={}, current_node=nil, level=0, init=true)
    	{:include_blank => false}.merge(options)
      html = ""
      if init 
        html << "<select name=\"#{name}\">\n"
        if options[:include_blank] == true
          if selected == nil
          	html << '<option selected="selected"></option>'
          else
            html << "<option></option>"
          end        	
        end
      end
      if selected == nil && PageNode.unrecycled.can_have_children.first && !options[:include_blank] == true
        selected = PageNode.unrecycled.can_have_children.first.id
      end
      for node in nodes.reject{|x| x.recycled? }
        unless node == current_node || node.ancestors.include?(current_node)
        	if node.can_have_children? || options[:insert_anywhere] == true
        		html << "\t<option value=\"#{node.id}\""
        	else
        		html << "\t<option value=\"#{node.id}\" disabled"
        	end
          html << ' selected="selected"' if selected && selected == node.id
          html << ">"
          level.times do 
            html << "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
          end
          html << "#{node.name}"
          html << "</option>\n"
        end
        html << tree_select(node.children, name, selected, options, current_node, level+1, false)
      end
      
      html << "</select>\n" if init
      return html
    end
    
  	def check_box_tree_tag(f, attribute, roots=nil, options={})

      defaults = {:manual_order => false,
                  :scrolling => true,
                  :children_method => "children",
                  :name_method => "name"}

      options = defaults.merge options
     
      attribute = attribute.to_s.singularize
      attribute_class = attribute.titleize.gsub(" ", "").constantize

      roots ||= attribute_class.roots
      
      ret = ""
      ret += render(:partial => "admin/shared/check_box_tree",
          	        :locals => {:nodes => roots,
                                :attribute => attribute.to_s.singularize,
                                :object => f.object,
                                :level => 0,
                                :options => options})
      ret
  	end
  	
  	def quick_fill_tag(target, options, name="Similar...")
	    ret = ""
	    ret += "<span style='float:right;'>"
	    ret += select_tag("#{target}_quick_fill", "<option value>#{name}</option>" + options_for_select(options), :onchange => "$('#{target}').value=this.value;  this.value=''; $('#{target}').highlight();")
      ret += "</span>"
      ret
	  end
  	
  end
  
  module FormBuilderMethods
  	
	  def check_box(attribute, attributes={})
	  	attributes = {:class => "checkbox"}.merge(attributes)
	    @template.check_box(@object_name, attribute, attributes)
	  end
    
    def object_select(object_class, object_id)
      object_class_element = "#{@object_name}_#{object_class}"
      object_id_element = "#{@object_name}_#{object_id}"
      ret = ""
      ret += "<a href = '/admin/html_popups/internal_link_for_content?element_object_class=#{object_class_element}&element_object_id=#{object_id_element}' rel='lyteframe' rev='width:800px;height:450px;'>Select Associated Link</a>"
      ret += " <span id='#{object_class_element}_done' style='display:none;color:green;'>New Link Selected</span>"
      ret += " <span id='#{object_class_element}_clear' style='display:none;color:red;'>Link Removed</span>"
      ret += @template.hidden_field(@object_name, object_class).to_s
      ret += @template.hidden_field(@object_name, object_id).to_s
      if @object.send(object_class.to_s+"?")
        ret += "<br />"
        ret += "Current Object: "
        ret += @object.send(object_class.to_s).singularize.humanize
        ret += " "
        if @object.send(object_class.to_s).singularize.camelcase.constantize.exists?(@object.send(object_id.to_s))
        	ret += "<script  type='text/javascript'>"      	
	      	ret += "function clear_#{object_class_element}(){"
	      	ret += "$('#{object_class_element}').value = '';"
	      	ret += "$('#{object_id_element}').value = '';"
	      	ret += "$('#{object_class_element}_clear').style['display'] = ''"
	      	ret += "}"
	      	ret += "</script>"
	      	ret += @object.send(object_class.to_s).singularize.camelcase.constantize.find(@object.send(object_id.to_s)).name
          ret += "<img src='/images/admin/delete.gif' onclick='clear_#{object_class_element}();' style='cursor:pointer;cursor:hand' /><br />"
        end
      end      
      ret
    end
    
    def picture_select(main_image_attribute, crops=[], options={})
    	options = {:readonly => false}.merge(options)
    	main_element = "#{@object_name}_#{main_image_attribute}".gsub("[","_").gsub("]","")
    	ret = ""
    	unless options[:readonly]
    		crop_string = ""
    		for crop in crops
    			crop[1] ||= "Frame Image"
    			crop_string += "&#{crop[0]}=#{crop[1]}&#{crop[0]}_w=#{crop[2]}&#{crop[0]}_h=#{crop[3]}&#{crop[0]}_element=#{"#{@object_name}_#{crop[0]}".gsub("[","_").gsub("]","")}"
    		end
        ret += "<a href = '/admin/html_popups/index_pictures_for_db?element=#{main_element}#{crop_string}' rel='lyteframe' rev='width:800px;height:450px;'>Select/Upload Picture</a>"
        ret += " <span id='#{main_element}_done' style='display:none;color:green;'>Image Updated</span>"
				ret += " <span id='#{main_element}_clear' style='display:none;color:red;'>Image Removed</span>"
      end
      if @object_name.include?("[")
      	if @object.send(main_image_attribute.to_s+"?") && Picture.exists?(@object.send(main_image_attribute))
      		ret += @template.hidden_field(@object_name, main_image_attribute, :value => @object.send(main_image_attribute.to_s)).to_s
      	else
      		ret += @template.hidden_field(@object_name, main_image_attribute).to_s
      	end
      else
      	ret += @template.hidden_field(@object_name, main_image_attribute).to_s
      end
      for crop in crops
      	ret += @template.hidden_field(@object_name, crop[0]).to_s
      end
      if @object.send(main_image_attribute.to_s+"?") && Picture.exists?(@object.send(main_image_attribute))
      	ret += "<script  type='text/javascript'>"      	
      	ret += "function clear_#{main_image_attribute}(){"
      	ret += "$('#{main_element}').value = '';"
      	for crop in crops
      		ret += "$('#{@object_name}_#{crop[0]}').value = '';"
      	end
      	ret += "$('#{main_element}_clear').style['display'] = ''"
      	ret += "}"
      	ret += "</script>"
        ret += "<br />"
        ret += "<img src='#{Picture.find(@object.send(main_image_attribute)).image.url(:thumb)}' />"
        ret += "<img src='/images/admin/delete.gif' onclick='clear_#{main_image_attribute}();' style='cursor:pointer;cursor:hand' /><br />"
      end
      ret
    end	  
	  
    def default_collection_select(attribute, options={})
      @template.collection_select(@object_name, attribute, attribute.to_s.gsub("_id", "").camelcase.constantize.find(:all, :order => "name asc"), :id, :name, options)
    end
    
    def helpful_label(attribute, label_text, title, attributes={})
      @template.label(@object_name, attribute, label_text, attributes.merge(:class => "help_icon", :onmouseover => "ddrivetip('#{title}')", :onmouseout => "hideddrivetip()"))
    end
    
    def memory_text_field(attribute, number=20)
  	  output = ''
  		output += @template.text_field(@object_name, attribute).to_s
  		@object.class.all.collect{|x| eval "x.#{attribute}" }.uniq[0..20].each do |y|
  		  output += "<span style='text-decoration:underline;' onClick='$(this).previous(\"input\").value = \"#{y}\";'>#{y}</span>  "
  		end
  		return output
  	end
  	
  	def simple_text_area(attribute, options={})
  	  @template.text_area(@object_name, attribute, :class => "simple", :value => @object.send(attribute)).to_s
  	end
  	
  	def advanced_text_area(attribute)
  	  @template.text_area(@object_name, attribute, :class => "advanced", :style => "width:450px;height:450px;", :value => @object.send(attribute)).to_s
  	end
  	
  	def linker_text_area(attribute, options={})
  	  @template.text_area(@object_name, attribute, :class => "linker", :style => "width:250px;height:250px;", :value => @object.send(attribute)).to_s
  	end
  	
  	def tag_field(attribute, default_tags=[])
  	  tag_list_name = attribute.to_s.singularize + "_list"
  	  ret = ""
  	  ret += @template.text_area(@object_name, tag_list_name, :rows => 2).to_s
  	  ret += "<div class='tag_zone'>"
  	  for tag in default_tags
  	  	ret += "<span class='tag' onClick='commaJoin($(\"#{@object_name}_#{tag_list_name}\"), \"#{tag}\");'>"
  	    ret += tag
  	    ret += "</span> "
  	  end
  	  for tag in object.class.unrecycled.tag_counts_on(attribute)
  	  	unless default_tags.include?(tag.name)
	  	    ret += "<span class='tag' onClick='commaJoin($(\"#{@object_name}_#{tag_list_name}\"), \"#{tag.name}\");'>"
	  	    ret += tag.name
	  	    ret += "</span> "
	    	end
  	  end
  	  ret += "</div>"
      ret
  	end
  	
  	def tag_select(attribute, options)
  	  tag_list_name = attribute.to_s.singularize + "_list"
  	  ret = ""
  	  ret += @template.text_field(@object_name, tag_list_name, :rows => 2, :readonly => true).to_s
  	  ret += "<div class='tag_zone'>"
  	  for tag in object.class.unrecycled.tag_counts_on(attribute)
  	    ret += "<span class='tag' onClick='commaJoin($(\"#{@object_name}_#{tag_list_name}\"), \"#{tag.name}\");'>"
  	    ret += tag.name
  	    ret += "</span> "
  	  end
  	  ret += "</div>"
      ret
  	end	
  	
  end

end
