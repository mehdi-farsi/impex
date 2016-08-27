module CSVImporter
  class Engine
    def initialize(options = {})
    end

    def run
      @config = CSVImporter.config

      @lookup = CSVImporter::Lookup.new(@config)

      @files_loader    = @lookup.file_loader
      @history_manager = @lookup.history_manager

      @files = @files_loader.load

      @files.each do |file|
        model = file.table

        file.each do |row|
            # the user can re-organize each row before saving.
            row = yield(row) if block_given?

            row = @history_manager.filter_data_with_history(row)

            record = model.find_or_initialize_by(reference: row.columns["reference"])
            byebug
            record.update!(row.columns.except(["reference"]))

            @history_manager.update_history(row)
        end
      end
    end

    class << self
      def run(options = {})
        CSVImporter::Engine.new(options).run
      end
    end
  end
end