module Impex
  module HistoryManager
    class Base
      def initialize(options = {})
        @options = options
        @whitelist = options[:history_whitelisting]
      end

      def load
        raise Impex::HistoryLoader::UnknownHistoryLoaderError
      end
    end
  end
end