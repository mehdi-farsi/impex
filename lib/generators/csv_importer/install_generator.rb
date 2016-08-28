module CsvImporter
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    argument :history_manager, :type => :string, default: "activerecord"

    def generate_export
      initializer_path = "#{Rails.root}/config/initializers/csv_importer.rb"
      copy_file "csv_importer.rb", initializer_path

      if history_manager == "activerecord"
        migration_path = "#{Rails.root}/db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_create_csv_importer_histories.rb"
        copy_file "create_csv_importer_history.rb", migration_path
      end
    end
  end
end