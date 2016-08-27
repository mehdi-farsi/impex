require "csv_importer/configuration"
require "csv_importer/engine"
require "csv_importer/lookup"
require "csv_importer/version"

module CSVImporter
  if defined?(Rails)
    class Railtie < Rails::Railtie
      rake_tasks do
        ::Dir[::File.join(::File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
      end
    end
  end
end
