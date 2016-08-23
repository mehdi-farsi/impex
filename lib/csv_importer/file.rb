require_relative "row.rb"

module CSVImporter
  class File
    extend  Forwardable
    def_delegators :@rows, :each, :[], :<<

    attr_reader :file, :table

    def initialize(file, config = {})
      @file = file
      @rows = []
      @table = config[:table]
    end
  end
end