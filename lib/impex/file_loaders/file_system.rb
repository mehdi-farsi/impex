require_relative "../file_loader/base.rb"
require_relative "../file_formatter.rb"

module Impex
  module FileLoader
    class FileSystem < Base
      # The method #load is responsible to
      # fetch all files (instances of Impex::File).
      # Each rows are stored as an array of Impex::Row.
      # The routine CSVImport::FileFormatter.build takes an instance of
      # File as parameter and returns an instance of Impex::File
      # which contains a set of Impex::Row accessible via :each method
      def load
        files = []
        ::Dir.glob("#{::Rails.root}/#{@options[:relative_path]}/csv_import/**/*.csv").each do |f|
          files << Impex::FileFormatter.build(::File.open(f))
        end
        files
      end
    end
  end
end