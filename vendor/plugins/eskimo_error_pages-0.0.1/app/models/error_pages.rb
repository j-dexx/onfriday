class ErrorPages

  def self.regenerate
    FileUtils.cd(File.join(RAILS_ROOT, "public"))
    system "wget -O '404.html' #{Mailer.default_url_options[:host]}/error_pages/e404"
    system "wget -O '500.html' #{Mailer.default_url_options[:host]}/error_pages/e500"
  end

end
