module CSVImporter
  module HistoryManager
    class Base
      def initialize(options = {})
        @options = options
        # @history is 2D hash that returns an Array.
        # e.g: @history[REFERENCE_ID]["email"] = ["email1", "email2"]
      end

      def load
        raise CSVImporter::HistoryLoader::UnknownHistoryLoaderError
      end
    end
  end
end