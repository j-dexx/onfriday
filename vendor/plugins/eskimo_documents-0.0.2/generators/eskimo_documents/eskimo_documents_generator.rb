class EskimoDocumentsGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.migration_template "create_documents_migration.rb.erb",
                           File.join('db', 'migrate'),
                           :migration_file_name => "create_documents"
    end
  end

end
