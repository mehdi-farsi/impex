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

  ###############
  # file loaders
  ###############

  def test_file_loader_with_invalid_file_loader_config_test
    assert_raises(CSVImporter::FileLoader::UnknownFileLoaderError) {
      @invalid_lookup.file_loader
    }
  end
end