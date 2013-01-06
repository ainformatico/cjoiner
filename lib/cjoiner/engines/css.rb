require 'sass'

module Cjoiner
  module Engines
    # engine for css files
    class Css < Cjoiner::Engines::Engine
      def initialize(opts)
        @engine = ::Sass::Engine.new(opts[:content],
        {
          :load_paths => opts[:paths],
          :style      => opts[:style] || :expanded
        }).render
      end
    end
  end
end
