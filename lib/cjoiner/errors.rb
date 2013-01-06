# -*- encoding: utf-8 -*-
module Cjoiner
  # holds all the errors for Cjoiner
  module Errors
    # a file was not found
    class FileNotFound < StandardError
      def initialize
        @message = "File not found"
      end
    end
  end
end
