require 'cjoiner/engine'

module Cjoiner
  module Engines
    # abstract class for engines
    class Engine
      include Cjoiner::Helpers::Files

      attr_reader :engine

      # used as abstract class
      def render
        @engine
      end
    end
  end
end
