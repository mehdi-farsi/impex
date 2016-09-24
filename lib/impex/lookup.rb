require_relative "file_loader/base.rb"
Dir.glob(File.join(File.dirname(__FILE__), 'file_loaders/*.rb')) do |f|
  require f
end

Dir.glob(File.join(File.dirname(__FILE__), 'history_managers/*.rb')) do |f|
  require f
end

require "active_support/hash_with_indifferent_access"

module Impex
  class Lookup
    attr_reader :config, :file_loaders, :history_managers

    def initialize(config = {})
      @config = config

      @file_loaders     = ::ActiveSupport::HashWithIndifferentAccess.new
      @history_managers = ::ActiveSupport::HashWithIndifferentAccess.new

      setup_file_loaders
      setup_history_managers
    end

    def file_loader
      lookup_for_file_loader
    end

    def history_manager
      lookup_for_history_manager
    end

    private
    def lookup_for_file_loader
      klass = @file_loaders[@config[:file_loader][:loader]]

      raise Impex::FileLoader::UnknownFileLoaderError,
            "undefined class #{@config[:file_loader][:loader].to_s.camelize}" if klass.nil?

      klass.new(@config[:file_loader])
    end

    def lookup_for_history_manager
      klass = @history_managers[@config[:history_manager][:manager]]

      raise Impex::HistoryManager::UnknownHistoryManagerError,
            "undefined class #{@config[:history_manager][:manager].to_s.camelize}" if klass.nil?

      klass.new(@config)
    end

    def setup_file_loaders
      ::Dir.glob(::File.join(::File.dirname(__FILE__), 'file_loaders/*.rb')).each do |file|
        /(?<klass>\w+)\.rb/ =~ file

        @file_loaders[klass] = "::Impex::FileLoader::#{klass.camelize}".constantize
      end
    end

    def setup_history_managers
      ::Dir.glob(::File.join(::File.dirname(__FILE__), 'history_managers/*.rb')).each do |file|
        /(?<klass>\w+)\.rb/ =~ file

        @history_managers[klass] = "::Impex::HistoryManager::#{klass.camelize}".constantize
      end
    end
  end
end