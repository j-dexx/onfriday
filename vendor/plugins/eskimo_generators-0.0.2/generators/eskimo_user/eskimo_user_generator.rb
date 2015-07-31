class EskimoUserGenerator < Rails::Generator::NamedBase
  
  def manifest
    record do |m|
      m.directory "app/models"
      m.template "model.rb", "app/models/#{file_name}.rb"
      m.template "mailer.rb", "app/models/#{file_name}_mailer.rb"
      m.template "session_model.rb", "app/models/#{file_name}_session.rb"
      m.migration_template "migration.rb", "db/migrate", :migration_file_name => "create_#{plural_name}"
      m.template "helper.rb", "app/helpers/#{plural_name}_helper.rb"
      
      m.directory "app/controllers"
      m.template "controller.rb", "app/controllers/#{plural_name}_controller.rb"
      m.template "session_controller.rb", "app/controllers/#{singular_name}_sessions_controller.rb"
      m.template "password_reset_controller.rb", "app/controllers/#{singular_name}_password_resets_controller.rb"
      m.directory "app/controllers/admin"
      m.template "admin_controller.rb", "app/controllers/admin/#{plural_name}_controller.rb"
      
      m.directory "app/views/#{plural_name}"
      for view in views
        m.template "views/#{view_language}/#{view}.html.#{view_language}", "app/views/#{plural_name}/#{view}.html.#{view_language}"
      end
      
      m.directory "app/views/#{singular_name}_sessions"
      for view in session_views
        m.template "views/#{view_language}/sessions/#{view}.html.#{view_language}", "app/views/#{singular_name}_sessions/#{view}.html.#{view_language}"
      end
      
      m.directory "app/views/#{singular_name}_mailer"
      m.template "views/#{view_language}/mailer/password_reset_instructions.html.#{view_language}", "app/views/#{singular_name}_mailer/password_reset_instructions.html.#{view_language}"
      
      m.directory "app/views/admin/#{plural_name}"
      for view in admin_views
        m.template "views/#{view_language}/admin/#{view}.html.#{view_language}", "app/views/admin/#{plural_name}/#{view}.html.#{view_language}"
      end
      
      m.directory "app/views/#{singular_name}_password_resets"
      m.template "views/#{view_language}/password_resets/new.html.#{view_language}", "app/views/#{singular_name}_password_resets/new.html.#{view_language}"
      m.template "views/#{view_language}/password_resets/edit.html.#{view_language}", "app/views/#{singular_name}_password_resets/edit.html.#{view_language}"
          
      m.route_resources plural_name
      m.route_resources "#{singular_name}_sessions"
      m.route_resources "#{singular_name}_password_resets"
      
      sentinel = 'ActionController::Routing::Routes.draw do |map|'
      m.gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
      "#{match}\n  map.#{singular_name}_login '#{singular_name}_login', :controller => '#{singular_name}_sessions', :action => 'new'\n  map.#{singular_name}_logout '#{singular_name}_logout', :controller => '#{singular_name}_sessions', :action => 'destroy'"
      end
      
      sentinel = 'map.namespace :admin do |admin|'
      m.gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
      "#{match}\n    admin.resources :#{plural_name}, :except => [:show]"
      end
      
      sentinel = 'class ApplicationController < ActionController::Base'
      m.gsub_file 'app/controllers/application_controller.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
      "#{match}\n  include #{ plural_class_name }Helper"
      end
      
      Feature.create!(:name => plural_title, :controller => "admin/#{plural_name}", :action => "", :position => 0, :super_admin_only => false, :location => "Website Content", :css_class => "")
    end
  end
  
  def views
    %w[edit index new _form _navigation]
  end
  
  def session_views
    %w[_login new]
  end
  
  def admin_views
    %w[edit _form index new]
  end
  
  def plural_class_name # e.g. Articles/BlogEntries
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
