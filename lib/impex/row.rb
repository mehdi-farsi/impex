module Impex
  class Row
    attr_reader :table, :columns

    def initialize(columns = {}, file_config = {})
      @columns = columns
      @table   = file_config[:table]
    end
  end
end