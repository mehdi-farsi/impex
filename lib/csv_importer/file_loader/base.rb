require_relative "errors.rb"

module CSVImporter
  module FileLoader
    class Base
      def initialize(options = {})
        @options = options
      end

      def load
        raise CSVImporter::FileLoader::UnknownFileLoaderError
      end
    end
  end
end