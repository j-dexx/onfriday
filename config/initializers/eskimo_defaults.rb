module ActionView
  module Helpers
  
    module AssetTagHelper
      def image_tag_with_defaults(source, options={})
        options[:vspace] ||= 0
        options[:hspace] ||= 0
        options[:border] ||= 0
        image_tag_without_defaults(source, options)
      end
      alias_method_chain :image_tag, :defaults
    end
    
    module TextHelper
      def simplish_format(text, html_options={}, options={})
        text = text ? text.to_str : ''
        text = text.dup if text.frozen?
        text.gsub!(/\r\n?/, "<br />")                    # \r\n and \r -> \n
        text.gsub!(/\n\n+/, "<br /><br />")  # 2+ newline  -> paragraph
        text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
        text = sanitize(text) unless options[:sanitize] == false
        text
      end
    end
    
  end
end
