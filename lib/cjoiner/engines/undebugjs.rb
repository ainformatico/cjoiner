module Cjoiner
  module Engines
    # eliminates js debug statements
    class UndebugJS < Cjoiner::Engines::Engine
      def initialize(opts)
        @keywords = []
        set_keywords!
        @engine = replace(opts[:content], opts[:prefix])
      end

      def add_keyword(keyword)
        @keywords << keyword
      end

      def set_keywords!
        add_keyword 'assert'
        add_keyword 'clear'
        add_keyword 'count'
        add_keyword 'debug'
        add_keyword 'dir'
        add_keyword 'dirxml'
        add_keyword 'error'
        add_keyword 'group'
        add_keyword 'groupCollapsed'
        add_keyword 'groupEnd'
        add_keyword 'info'
        add_keyword 'log'
        add_keyword 'profile'
        add_keyword 'profileEnd'
        add_keyword 'time'
        add_keyword 'timeEnd'
        add_keyword 'timeStamp'
        add_keyword 'trace'
        add_keyword 'warn'
        add_keyword 'debugger'
        add_keyword 'ungroup'
      end

      protected
        def replace(str, prefix)
          output = str
          @keywords.each do|keyword|
            output.gsub!(/^(\s*)?#{prefix}\.#{keyword}\(.*\);?\n?/, '')
          end
          output
        end
    end
  end
end
