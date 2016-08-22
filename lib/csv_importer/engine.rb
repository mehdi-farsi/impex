module CSVImporter
  class Engine
    def initialize(options = {})
    end

    def run
      @config = CSVImporter.config

      @lookup = CSVImporter::Lookup.new(@config)

      @files_loader   = @lookup.file_loader
      # @history_loader = @lookup.history_loader

      @files = @files_loader.load

      # @files.each do |file|
      #   file.each do |row|
      #     if block_given?
      #       # delegate the insertion/update rules to the user of the lib
      #       yield(row) if block_given?
      #     else
      #       file.table.create(row)
      #     end
      #   end
      # end
    end

    class << self
      def run(options = {})
        CSVImporter::Engine.new(options).run
      end
    end
  end
end