require 'test_helper'

class EngineTest < Minitest::Test
  def setup
  end

  def teardown
    Building.delete_all
    Impex::Lookup.unstub(:file_loader)
    Impex::Lookup.unstub(:history_manager)
  end

  def test_methods_called_in_run_method
    lookup = Impex::Lookup.new(config_test)
    file   = Impex::File.new(File.join(File.expand_path(__FILE__), "data/buildings/4242.csv"), table: "buildings")


    Impex.expects(:config).returns(config_test)
    Impex::Lookup.expects(:new).returns(lookup)

    Impex::Lookup.any_instance.expects(:file_loader).returns(Impex::FileLoader::FileSystem.new(config_test[:file_loader]))
    Impex::Lookup.any_instance.expects(:history_manager).returns(Impex::HistoryManager::ActiveRecord.new(config_test))

    Impex::FileLoader::FileSystem.any_instance.expects(:load).returns([file])

    Impex::Engine.run
  end
end
