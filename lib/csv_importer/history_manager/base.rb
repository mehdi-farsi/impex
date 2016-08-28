module CSVImporter
  module HistoryManager
    class Base
      def initialize(options = {})
        @options = options
        @whitelist = options[:history_whitelisting]
      end

      def load
        raise CSVImporter::HistoryLoader::UnknownHistoryLoaderError
      end
    end
  end
end