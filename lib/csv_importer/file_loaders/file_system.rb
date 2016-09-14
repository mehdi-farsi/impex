require_relative "../file_loader/base.rb"
require_relative "../file_formatter.rb"

module CSVImporter
  module FileLoader
    class FileSystem < Base
      # The method #load is responsible to
      # fetch all files (instances of CSVImporter::File).
      # Each rows are stored as an array of CSVImporter::Row.
      # The routine CSVImport::FileFormatter.build takes an instance of
      # File as parameter and returns an instance of CSVImporter::File
      # which contains a set of CSVImporter::Row accessible via :each method
      def load
        files = []
        ::Dir.glob("#{::Rails.root}/#{@options[:relative_path]}/csv_import/**/*.csv").each do |f|
          files << CSVImporter::FileFormatter.build(::File.open(f))
        end
        files
      end
    end
  end
end