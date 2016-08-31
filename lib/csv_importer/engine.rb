module CSVImporter
  class Engine
    def initialize(options = {})
    end

    def run(&block)
      @config = CSVImporter.config

      @lookup = CSVImporter::Lookup.new(@config)

      @files_loader    = @lookup.file_loader
      @history_manager = @lookup.history_manager

      @files = @files_loader.load

      @files.each do |file|
        model = file.table

        file.each do |row|
          # the user can re-organize each row before saving.
          row = block.call(row) if block

          row = @history_manager.filter_data_with_history(row)

          record = model.find_or_initialize_by(reference: row.columns["reference"])

          insert_row(record, row.columns.except(["reference"]))

          @history_manager.update_history(row)
        end
      end
    end

    private
    # override this method to change the insertion behavior.
    # For example. you can skip validations for some specific models, etc..
    def insert_row(record, columns)
      record.update!(columns)
    end

    class << self
      def run(options = {}, &block)
        CSVImporter::Engine.new(options).run(&block)
      end
    end
  end
end