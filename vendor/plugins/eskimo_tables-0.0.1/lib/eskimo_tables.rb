module EskimoTables
  require File.dirname(__FILE__) + "/eskimo/tables/helper_extension"
  ActiveRecord::Base.send :include, Eskimo::Tables::HelperExtension
end
