namespace :csv_importer do
  desc "Import all files"
  task :all => :environment do
    CSVImporter::Engine.run
  end
end