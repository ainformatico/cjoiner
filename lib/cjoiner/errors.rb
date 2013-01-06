# -*- encoding: utf-8 -*-
module Cjoiner
  module Errors
    class FileNotFound < StandardError
      def initialize
        @message = "File not found"
      end
    end
  end
end
