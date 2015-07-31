class EskimoEventGenerator < Rails::Generator::NamedBase
  
  def manifest
    record do |m|
      m.directory "app/models"
      m.template "model.rb", "app/models/#{file_name}.rb"
      m.migration_template "migration.rb", "db/migrate", :migration_file_name => "create_#{plural_name}"
      
      m.directory "app/controllers"
      m.template "controller.rb", "app/controllers/#{plural_name}_controller.rb"
      m.directory "app/controllers/admin"
      m.template "admin_controller.rb", "app/controllers/admin/#{plural_name}_controller.rb"
      
      m.directory "app/views/#{plural_name}"
      for view in views
        m.template "views/#{view_language}/#{view}.html.#{view_language}", "app/views/#{plural_name}/#{view}.html.#{view_language}"
      end
      m.template "views/#{view_language}/_model.html.#{view_language}", "app/views/#{plural_name}/_#{file_name}.html.#{view_language}"
      
      m.directory "app/views/admin/#{plural_name}"
      for view in admin_views
        m.template "views/#{view_language}/admin/#{view}.html.#{view_language}", "app/views/admin/#{plural_name}/#{view}.html.#{view_language}"
      end
          
      m.route_resources plural_name
      sentinel = 'map.namespace :admin do |admin|'
      m.gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
      "#{match}\n    admin.resources :#{plural_name}, :except => [:show]"
      end
      Feature.create!(:name => plural_title, :controller => "admin/#{plural_name}", :action => "", :position => 0, :super_admin_only => false, :location => "Website Content", :css_class => "")
    end
  end
  
  def views
    %w[_dates _tags show index]
  end
  
  def admin_views
    %w[edit _form index new]
  end
  
  def plural_class_name # e.g. Articles/Blog Entries
    class_name.pluralize
  end
  
  def plural_title
    plural_name.titleize # e.g. Articles/Blog Entries
  end
  
  def singular_title
    singular_name.titleize # e.g. Article/Blog Entry
  end
  
  def human_plural_name # e.g. Articles/Blog entries
    plural_name.humanize
  end
  
  def human_singular_name # e.g. Article/Blog entry
    singular_name.humanize
  end
  
  def view_language
    "erb"
  end
  
end
