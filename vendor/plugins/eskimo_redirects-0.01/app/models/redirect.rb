class Redirect

  def self.read_file
    redirects = []
    file = File.open "../redirects", "r"
    begin
      file.readline
      file.readline
      file.readline
      redirects << file.readline.split[2, 2] while true
    rescue EOFError
      return redirects
    end
  end

  def self.write_file(host, redirects=nil)
    unless redirects.nil?
      redirects_to_delete = []
      redirects.delete ["", ""]
      redirects = redirects.uniq
      
      for redirect in redirects
        if redirect[0] == "" || redirect[1] == ""
          redirects_to_delete << redirect
          next
        end
        
        unless redirect[0][0,1] == "/"
          redirects << ["/" + redirect[0], redirect[1]]
          redirects_to_delete << redirect
          next
        end
        
        unless redirect[1].scan(/http:\/\/[\w:.\/-]*/).include? redirect[1]
          for redirect in redirects_to_delete
            redirects.delete redirect
          end
          raise "#{redirect[1]} does not look like a valid URL."
        end
        
        if redirects.select{|x| x != redirect}.collect{|x| x[0]}.include? redirect[0]
          for redirect in redirects_to_delete
            redirects.delete redirect
          end
          raise "#{redirect[0]} points to two different locations. Redirects file was not written."
        end
      end
      
      for redirect in redirects_to_delete
        redirects.delete redirect
      end
      
      redirects = redirects.uniq
      
      `rm -f ../redirects`
      
      file = File.new "../redirects", "w"
      unless redirects.empty?
        file.puts "RewriteEngine on"
        file.puts "rewritecond %{http_host} ^#{host.gsub("www.", "")} [nc]"
        file.puts "rewriterule ^(.*)$ /$1 [r=301,nc]"
        for redirect in redirects
          file.puts "redirect 301 #{redirect[0]} #{redirect[1]}"
        end
      end
      file.close
    end    
  end
  
end
