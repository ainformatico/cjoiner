module Cjoiner
  module Engines
    # join files
    class Joiner < Cjoiner::Engines::Engine
      def initialize(opts)
        output = ""
        opts[:files].each do |file|
          output << read_file(file) << "\n"
        end
        @engine = output
      end
    end
  end
end
