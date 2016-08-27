module CSVImporter
  module HistoryManager
    class Base
      def initialize(options = {})
        @options = options
      end

      def load
        raise CSVImporter::HistoryLoader::UnknownHistoryLoaderError
      end
    end
  end
end