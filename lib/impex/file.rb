require_relative "row.rb"

module Impex
  class File
    extend  Forwardable
    def_delegators :@rows, :each, :[], :<<
    alias each_row each

    attr_reader :file, :table

    def initialize(file, config = {})
      @file = file
      @rows = []
      @table = config[:table].classify.constantize
    end
  end
end