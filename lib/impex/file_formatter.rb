require_relative "file.rb"
require_relative "row.rb"

require "csv"

module Impex
  class FileFormatter
    class << self
      def build(csv_file)
        table = find_table_name(csv_file.path)
        file_config = {
          table: table
        }

        file = Impex::File.new(csv_file, file_config)

        ::CSV.read(csv_file, headers: true).each do |row|
          file << Impex::Row.new(row.to_h, file_config)
        end
        file
      end

      def find_table_name(filename)
        filename[/\/(\w+)\/\w+.csv$/, 1]
      end
    end
  end
end