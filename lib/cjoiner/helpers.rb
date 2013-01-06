require 'fileutils'
require 'tempfile'
require 'cjoiner/errors'

module Cjoiner
  module Helpers
    module Files
      # check if a file exists
      def file_exists(file, halt = true)
        check = ::File.exists? file
        raise(Cjoiner::Errors::FileNotFound, file) if !check and halt
        check
      end

      # load a yaml file
      def load_yaml(file)
        if file_exists(file)
          ::YAML::load_file(file)
        end
      end

      # move a file
      def move_file(from, to)
        FileUtils.mv from, to
      end

      # read file
      def read_file(file)
        File.read(file) if file_exists file
      end

      # write data to file
      def write_file(file, data)
        file.open("w") { |io| io.puts data }
      end

      # create a temporal file
      def temp_file(file, data)
        temp = Tempfile.new(file) << data
        temp.close
        temp
      end
    end
  end
end