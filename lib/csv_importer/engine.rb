module CSVImporter
  class Engine
    def initialize(options = {})
      
    end

    def run
      puts "I run the game !!"
    end

    class << self
      def run(options = {})
        ::CSVImporter::Engine.new(options).run
      end
    end
  end
end