require_relative "errors.rb"

module Impex
  module FileLoader
    class Base
      def initialize(options = {})
        @options = options
      end

      def load
        raise Impex::FileLoader::UnknownFileLoaderError
      end
    end
  end
end