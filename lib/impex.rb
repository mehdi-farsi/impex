require "impex/configuration"
require "impex/engine"
require "impex/lookup"
require "impex/version"

module Impex
  if defined?(Rails)
    class Railtie < Rails::Railtie
      rake_tasks do
        ::Dir[::File.join(::File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
      end
    end
  end
end
