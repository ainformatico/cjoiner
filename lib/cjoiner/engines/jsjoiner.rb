require 'sprockets'
require 'pry'

#NOTE: underscore.js interpolation hash(<%=(.*?)%>) conflicts with Sprockets
#      and raises UndefinedConstantError.
#
#     In order to avoid this behavior I just avoid the raise statement
#     and always return the value

module Sprockets
  class SourceLine
    protected
      def interpolate_constants!(result, constants)
        result.gsub!(/<%=(.*?)%>/) do
          constant = $1.strip
          if value = constants[constant]
            value
          else
            puts "WARNING: couldn't find constant `#{constant}' in #{inspect}"
            value
          end
        end
      end
  end
end

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
