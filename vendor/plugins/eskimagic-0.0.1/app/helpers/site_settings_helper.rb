module SiteSettingsHelper
	
	def parse_input_type(input_type, value)
	  case input_type
	    when "text_field"
    	  text_field_tag("site_setting[value]", value)
    	when "text_area"
      	text_area_tag("site_setting[value]", value)
      when "true/false"
        select_tag("site_setting[value]", options_for_select(["true", "false"], value))
      end
	end
	
end
