require 'yaml'
require 'fileutils'
require 'tempfile'
require 'pathname'
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
        return false if from == to
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
        # due to some java+windows+cygwin limitation
        # we need to create our custom tempfile
        if on_windows
          name = "_cjoiner_tmp_#{file}"
          temp = File.new(name, "w")
          temp.write(data)
        else
          temp = Tempfile.new(file) << data
        end
        temp.close
        temp
      end

      # delete a file, can be File or String
      def delete_file(file)
        item = file.kind_of?(File) ? file.path : file
        File.delete item
      end

      # RUBY_PLATFORM tells cygwin or mswin
      def on_windows
        (RUBY_PLATFORM =~ /cygwin|mswin/) != nil
      end

      # return Pathname.new.expand_path
      def expand_path(file)
        Pathname.new(file).expand_path
      end

      # use Pathname
      def file(file)
        Pathname.new file
      end
    end
  end
end
