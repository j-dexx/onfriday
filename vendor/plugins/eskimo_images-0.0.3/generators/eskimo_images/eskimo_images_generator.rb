class EskimoImagesGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.migration_template "create_images_migration.rb.erb",
                           File.join('db', 'migrate'),
                           :migration_file_name => "create_images"
    end
  end

end
