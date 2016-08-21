require 'yaml'

module CSVImporter
  @config = {
  }

  @valid_config_keys = %I[
    csv_importer_file_loader
    csv_importer_store_history
  ]

  # Configure through hash
  def self.configure(options = {})
    options.each do |k,v|
      @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym
    end

    puts "*"*50, "MYCONFIG", "*"*50
    p config
  end

  # Configure through yaml file
  def self.configure_with(path_to_yaml_file)
    begin
      config = YAML::load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
    rescue Psych::SyntaxError
      log(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
    end

    configure(config)
  end

  def self.config
    @config
  end
end