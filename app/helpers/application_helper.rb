# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	
	def determine_page_node
		if @page_node
			@current_page_node = @page_node
		elsif PageNode.controller_action(params[:controller], params[:action]).first
			@current_page_node = PageNode.controller_action(params[:controller], params[:action]).sort_by{|x| x.position}.first
		elsif PageNode.controller_action(params[:controller], "").first
			@current_page_node = PageNode.controller_action(params[:controller], "").sort_by{|x| x.position}.first
		else
			nil
		end
	end
	
	def number_to_pounds(number)
	  number_to_currency(number, :unit => "&pound;")
	end
	
	def tidy(number_string)
	  return "#{number_to_pounds(number_string.split("-").first)} to #{number_to_pounds(number_string.split("-").last)}"
	end
	
  def link_to_page(link_text, page_name, options={})
    page_node = PageNode.find_by_name(page_name)
    if page_node
      if !page_node.display? && options[:behaviour] == "hide"
        return ""
      elsif !page_node.display? && options[:behaviour] == "highlight"
        return link_to(link_text, page_node.path, options.merge(:style => "border: 2px #FF0000 solid;"))
      else
        return link_to(link_text, page_node.path, options)
      end
    else
      if options[:behaviour] == "hide"
        return ""
      elsif options[:behaviour] == "highlight"
        return link_to(link_text, "/404.html", options.merge(:style => "border: 2px #FF0000 solid;"))
      else
        return link_to(link_text, "/404.html", options)
      end
    end
  end
  
end
