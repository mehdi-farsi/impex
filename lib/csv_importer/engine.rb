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
        model  = file.table

        file.each do |row|
            # the user can re-organize each row before saving.
            row = yield(row) if block_given?

            reference = row.columns.delete("reference")
            row = @history_manager.filter_data_with_history(reference, row)

            record = model.find_or_initilize_by!(row.columns["reference"])

            record.update()

            history_manager.update_history(rerow)
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