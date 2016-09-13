require "yaml"
require "rails"

module CSVImporter
  @config = {
    file_loader: { loader: :file_system, path: "#{Rails.root}public/" },
    history_manager: { manager: :active_record, table: "csv_importer_histories" },
    history_whitelisting: {},
    history_references: {}
  }

  @valid_config_keys = %I[
    file_loader
    history_manager
    history_whitelisting
  ]

  # Configure through hash
  def self.configure(options = {})
    options.each do |k,v|
      @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym
    end

    @config
  end

  def self.config
    @config
  end
end