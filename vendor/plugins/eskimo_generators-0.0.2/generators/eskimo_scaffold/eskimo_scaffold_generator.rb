class EskimoScaffoldGenerator < Rails::Generator::Base
  attr_accessor :name, :attributes, :controller_actions
  
  def initialize(runtime_args, runtime_options = {})
    super
    usage if @args.empty?
    
    @name = @args.first
    @controller_actions = []
    @admin_controller_actions = []
    @attributes = []
    
    @args[1..-1].each do |arg|
      if arg.include? ':'
        @attributes << Rails::Generator::GeneratedAttribute.new(*arg.split(":"))
      elsif args.include? 'admin_'
        @admin_controller_actions << arg.gsub('admin_', '')
        @admin_controller_actions << 'create' if arg == 'new'
        @admin_controller_actions << 'update' if arg == 'edit'
      else
        @controller_actions << arg
        @controller_actions << 'create' if arg == 'new'
        @controller_actions << 'update' if arg == 'edit'
      end
    end
    
    @controller_actions.uniq!
    @admin_controller_actions.uniq!
    @attributes.uniq!
    
    if @controller_actions.empty?
      @controller_actions = all_actions
    end
    if @admin_controller_actions.empty?
      @admin_controller_actions = all_admin_actions
    end
    
    if @attributes.empty?
      options[:skip_model] = true # default to skipping model if no attributes passed
      if model_exists?
        model_columns_for_attributes.each do |column|
          @attributes << Rails::Generator::GeneratedAttribute.new(column.name.to_s, column.type.to_s)
        end
      else
        @attributes << Rails::Generator::GeneratedAttribute.new('name', 'string')
      end
    end
  end
  
  def manifest
    record do |m|
      unless options[:skip_model]
        m.directory "app/models"
        m.template "model.rb", "app/models/#{singular_name}.rb"
        unless options[:skip_migration]
          m.migration_template "migration.rb", "db/migrate", :migration_file_name => "create_#{plural_name}"
        end
      end
      
      unless options[:skip_controller]
        m.directory "app/controllers"
        unless options[:only_admin]
          m.template "controller.rb", "app/controllers/#{plural_name}_controller.rb"
        end
        unless options[:only_front]
          m.directory "app/controllers/admin"
          m.template "admin_controller.rb", "app/controllers/admin/#{plural_name}_controller.rb"
        end
      end
        
      unless options[:skip_view]
        unless options[:only_admin]
          m.directory "app/views/#{plural_name}"
          @controller_actions.each do |action|
            if File.exist? source_path("views/#{view_language}/#{action}.html.#{view_language}")
              m.template "views/#{view_language}/#{action}.html.#{view_language}", "app/views/#{plural_name}/#{action}.html.#{view_language}"
            end
          end
        end
        unless options[:only_front]
          m.directory "app/views/admin/#{plural_name}"
          @admin_controller_actions.each do |action|
            if File.exist? source_path("views/#{view_language}/admin/#{action}.html.#{view_language}")
              m.template "views/#{view_language}/admin/#{action}.html.#{view_language}", "app/views/admin/#{plural_name}/#{action}.html.#{view_language}"
            end
          end
          m.template "views/#{view_language}/admin/_form.html.#{view_language}", "app/views/admin/#{plural_name}/_form.html.#{view_language}"
          
          # alter the routes
          unless options[:skip_route]
            unless options[:only_admin]
              m.route_resources plural_name
            end
            unless options[:only_front]
              sentinel = 'map.namespace :admin do |admin|'
              m.gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
              "#{match}\n
    admin.resources :#{plural_name}, :except => [:show]"
              end
            end
          end
        end
      end
      Feature.create!(:name => plural_name.titleize, :controller => "admin/#{plural_name}", :action => "", :position => 0, :super_admin_only => false, :location => "Website Content", :css_class => "")
    end
  end
  
  def all_actions
    %w[index show]
  end
  
  def all_admin_actions
    %w[index new create edit update order destroy]
  end
  
  def singular_name
    name.underscore
  end
  
  def plural_name
    name.underscore.pluralize
  end
  
  def class_name
    name.camelize
  end
  
  def plural_class_name
    plural_name.camelize
  end
  
  def controller_methods(dir_name)
    @controller_actions.map do |action|
      read_template("#{dir_name}/#{action}.rb")
    end.join("  \n\n").strip
  end
  
  def admin_controller_methods(dir_name)
    @admin_controller_actions.map do |action|
      read_template("#{dir_name}/#{action}.rb")
    end.join("  \n\n").strip
  end
  
  def render_form
    "<%= render :partial => 'form' %>"
  end
  
  def model_columns_for_attributes
    class_name.constantize.columns.reject do |column|
      column.name.to_s =~ /^(id|created_at|updated_at)$/
    end
  end
  
  def action?(name)
    @controller_actions.include? name.to_s
  end
  
  def admin_action?(name)
    @admin_controller_actions.include? name.to_s
  end
  
protected
  
  def view_language
    options[:haml] ? 'haml' : 'erb'
  end
  
  def test_framework
    options[:test_framework] ||= default_test_framework
  end
  
  def default_test_framework
    File.exist?(destination_path("spec")) ? :rspec : :testunit
  end
  
  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--skip-model", "Don't generate a model or migration file.") { |v| options[:skip_model] = v }
    opt.on("--skip-migration", "Don't generate migration file for model.") { |v| options[:skip_migration] = v }
    opt.on("--skip-controller", "Don't generate controller.") { |v| options[:skip_controller] = v }
    opt.on("--skip-view", "Don't generate views.") { |v| options[:skip_view] = v }
    opt.on("--invert", "Generate all controller actions except these mentioned.") { |v| options[:invert] = v }
    opt.on("--only-front", "Only generate the front end views.") { |v| options[:only_front] = v }
    opt.on("--only-admin", "Only generate the admin views.") { |v| options[:only_admin] = v }
    opt.on("--skip-route", "Don't add a route to the environment.") { |v| options[:skip_route] = v }
  end
  
  # is there a better way to do this? Perhaps with const_defined?
  def model_exists?
    File.exist? destination_path("app/models/#{singular_name}.rb")
  end
  
  def read_template(relative_path)
    ERB.new(File.read(source_path(relative_path)), nil, '-').result(binding)
  end

end
