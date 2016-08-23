require_relative "file.rb"
require_relative "row.rb"

require "csv"

module CSVImporter
  class FileFormatter
    class << self
      def build(csv_file)
        table = find_table_name(csv_file.path)
        file_config = {
          table: table
        }

        file = CSVImporter::File.new(csv_file, file_config)

        ::CSV.read(csv_file, headers: true).each do |row|
          file << CSVImporter::Row.new(row, file_config)
        end
      end

      def find_table_name(filename)
        filename[/\/(\w+)\/\w+.csv$/, 1]
      end
    end
  end
end