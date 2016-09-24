require 'test_helper'

class LookupTest < Minitest::Test
  def setup
    @lookup = Impex::Lookup.new(config_test)

    invalid_config = config_test.dup
    invalid_config[:file_loader][:loader] = "unknown"
    @invalid_lookup = Impex::Lookup.new(invalid_config)
  end

  def teardown
    Building.destroy_all
  end

  ###############
  # file loaders
  ###############

  def test_file_loader_with_invalid_file_loader_config_test
    assert_raises(Impex::FileLoader::UnknownFileLoaderError) {
      @invalid_lookup.file_loader
    }
  end
end