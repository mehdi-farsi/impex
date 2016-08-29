require 'test_helper'

class EngineTest < Minitest::Test
  def setup
  end

  def teardown
    Building.delete_all
    CSVImporter::Lookup.unstub(:file_loader)
    CSVImporter::Lookup.unstub(:history_manager)
  end

  def test_methods_called_in_run_method
    lookup = CSVImporter::Lookup.new(config_test)
    file   = CSVImporter::File.new(File.join(File.expand_path(__FILE__), "data/buildings/4242.csv"), table: "buildings")


    CSVImporter.expects(:config).returns(config_test)
    CSVImporter::Lookup.expects(:new).returns(lookup)

    CSVImporter::Lookup.any_instance.expects(:file_loader).returns(CSVImporter::FileLoader::FileSystem.new(config_test[:file_loader]))
    CSVImporter::Lookup.any_instance.expects(:history_manager).returns(CSVImporter::HistoryManager::ActiveRecord.new(config_test))

    CSVImporter::FileLoader::FileSystem.any_instance.expects(:load).returns([file])

    CSVImporter::Engine.run
  end
end
