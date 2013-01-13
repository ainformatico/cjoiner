require 'yui/compressor'

module Cjoiner
  module Engines
    # compress content
    class Compressor < Cjoiner::Engines::Engine
      def initialize(opts)
        # use the standalone java jar file
        if opts[:yui]
          temp = temp_file "cjoiner.#{opts[:type]}", opts[:content]
          munge = !opts[:munge] ? "--nomunge" : ""
          @engine = `java -jar #{opts[:yui]} #{munge} --charset #{opts[:charset]} --type #{opts[:type]} #{temp.path}` if file_exists opts[:yui]
        else
          case opts[:type]
            when :css
              compressor = ::YUI::CssCompressor.new(:charset => opts[:charset])
            when :js
              compressor = ::YUI::JavaScriptCompressor.new(:munge => opts[:munge], :charset => opts[:charset])
          end
          if compressor
            @engine = compressor.compress(opts[:content])
          else
            @engine = opts[:content]
          end
        end
      end
    end
  end
end
