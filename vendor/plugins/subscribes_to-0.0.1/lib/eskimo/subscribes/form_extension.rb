module Eskimo::Subscribes::FormExtension

  def self.included(base)
    ActionView::Helpers::FormBuilder.instance_eval do 
      include FormBuilderMethods
    end
  end
  
  module FormBuilderMethods
    # Only works with page nodes at the minute. Needs a method for assigning the input name dynamically.
	  def subscription_select
	    tag_array_name = "tag_subscribe_array"
	    ret = ""
	    unless @object.subscription_options.empty?
	      ret += "<div id='" + @object_name + "' style='overflow:auto;' class='subscription_select'><ul>"
        for tag in @object.subscription_options
          ret += "<input name='page_node[page_contents_attributes][0][" + tag_array_name + "][]'"
          ret += "       value='" + tag.name + "'" 
          ret += "       type='checkbox'"
          ret += "       class='checkbox'"
          ret += "       id='cb" + tag.id.to_s + "'" 
          ret += "       size='3'"
          if @object.tag_subscribe_list.include? tag.name
            ret += "       checked=''>"
          else
            ret += ">"
          end
          ret += "<label style='font-weight: normal;' for='cb" + tag.id.to_s + "'>" 
          ret += tag.name
          ret += "<label><br />"
        end
      else
        ret += "<div id='" + @object_name + "' style='overflow:auto;background-color:#eeeeee;' class='subscription_select'><ul>"
        ret += "<label>There are currently no tags to subscribe to.</label>"
      end
      ret += "</ul></div>"
      ret
	  end
  end
end
