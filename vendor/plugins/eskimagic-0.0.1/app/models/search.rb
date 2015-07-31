class Search

  def self.site(search_term="")
    search_term = search_term.downcase
    results = []
    objects_to_search = []
    
    for page_node in PageNode.models
      
      begin
        page_node_model = page_node.model.singularize.camelcase.constantize
        
        if page_node_model.search_string.include? search_term
          for object in page_node_model.all
            results << object
          end
        else
          for object in page_node_model.all
            objects_to_search << object
          end
        end
      rescue Exception => e  
        puts e
      end
      
      for page_content in PageContent.active
        objects_to_search << page_content
      end
      
    end
      
    3.times do |count|
      for object in objects_to_search
 
        begin
          
          if object.send("search_string_#{count+1}") != nil && object.send("search_string_#{count+1}").downcase.include?(search_term)
            
            results << object
            objects_to_search.delete object
          end        
          
        rescue
          raise object.send("search_string_#{count+1}").to_yaml
        end
        
      end
    end
    results
  end
  
end