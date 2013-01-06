require 'sprockets'

module Cjoiner
  module Engines
    # engine for js files
    class JsJoiner < Cjoiner::Engines::Engine
      def initialize(opts)
        @engine = ::Sprockets::Secretary.new(
          :load_path    => opts[:paths],
          :source_files => opts[:sources]
        ).concatenation.to_s
      end
    end
  end
end
