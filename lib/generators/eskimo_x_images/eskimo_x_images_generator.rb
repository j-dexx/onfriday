class EskimoXImagesGenerator < Rails::Generator::NamedBase
  
  def manifest
    record do |m|
      m.directory "app/models"
      m.template "model.rb", "app/models/#{file_name}_image.rb"
      m.migration_template "migration.rb", "db/migrate", :migration_file_name => "create_#{singular_name}_images"
      
      m.directory "app/controllers/admin"
      m.template "admin_controller.rb", "app/controllers/admin/#{singular_name}_images_controller.rb"
      
      m.directory "app/views/admin/#{singular_name}_images"
      for view in admin_views
        m.template "views/#{view_language}/admin/#{view}.html.#{view_language}", "app/views/admin/#{singular_name}_images/#{view}.html.#{view_language}"
      end
          
      sentinel = 'map.namespace :admin do |admin|'
      m.gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
      "#{match}\n    admin.resources :#{singular_name}_images, :except => [:show]"
      end
    end
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
