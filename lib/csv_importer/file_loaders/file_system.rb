require_relative "../file_loader/base.rb"

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
        Dir.glob("#{Rails.root}/#{@options[:path]}/csv_import/**/*.csv").each do |f|
          p f
        end
      end
    end
  end
end