require 'test_helper'

class LookupTest < Minitest::Test
  def setup
    @lookup = CSVImporter::Lookup.new(config_test)

    invalid_config = config_test.dup
    invalid_config[:file_loader][:loader] = "unknown"
    @invalid_lookup = CSVImporter::Lookup.new(invalid_config)
  end

  def teardown
    Building.destroy_all
  end

  #####################
  # instance variables
  #####################

  def test_instance_variables_are_set
    assert @lookup.config == config_test

    assert_instance_of ActiveSupport::HashWithIndifferentAccess, @lookup.file_loaders
    assert @lookup.file_loaders[:file_system] == "::CSVImporter::FileLoader::FileSystem"


    assert_instance_of ActiveSupport::HashWithIndifferentAccess, @lookup.history_managers
    assert @lookup.history_managers[:active_record] == "::CSVImporter::HistoryManager::ActiveRecord"
  end

  ###############
  # file loaders
  ###############

  def test_file_loader_with_invalid_file_loader_config_test
    assert_raises(CSVImporter::FileLoader::UnknownFileLoaderError) {
      @invalid_lookup.file_loader
    }
  end

  def test_loader_with_valid_file_loader_config_test
    assert_instance_of CSVImporter::FileLoader::FileSystem, @lookup.file_loader
  end
end