# -*- encoding: utf-8 -*-
require "cjoiner/version"
require "cjoiner/errors"

# system
require 'fileutils'
require 'pathname'
require 'yaml'
require 'tempfile'

# gems
require 'rubygems'
require 'sass'
require 'sprockets'
require 'yui/compressor'

#
# @author Alejandro El Informático
#
# @version 1.1.2
#
# @created 20111105
#
# @modified 20120714
#
# @require gems [sass, sprockets 1.0.2, yui/compressor]
#

# yaml structure
# @config
#   @compress bool
#   @munge bool
#   @standalone bool
#   @yui string
#   @charset string
#   @debug bool
#   @debug_suffix string
#   @common_path string
#   @common_output string
#   @common_dependencies []
#   @file string
#     @name string
#     @extension string
#     @type string
#     @major int
#     @minor int
#     @bugfix int
#     @compilation int
#     @compress bool
#     @dependencies []
#     @output string

module Cjoiner
  class Joiner
    # load the configuration file
    def load_config!(config_file)
      if File.exists?(config_file)
        loaded_config = ::YAML::load_file(config_file)["config"]
        @config.merge!(loaded_config)
      else
        raise Cjoiner::Errors::FileNotFound
      end
    end

    #process all the configuration
    def proccess!
      #each filename with its options
      @config["files"].each do |filename, file_opts|
        # set file path and name
        file_full_path = @config["common_path"] + filename
        full_filename = Pathname.new(file_full_path)
        output_name = %[#{file_opts["name"]}.#{file_opts["major"]}.#{file_opts["minor"]}.#{file_opts["bugfix"]}.#{file_opts["compilation"]}.#{file_opts["extension"]}]
        debug_name = %[#{file_opts["name"]}.#{@config["debug_suffix"]}.#{file_opts["extension"]}]
        t_file = full_filename.dirname + output_name
        d_file = full_filename.dirname + debug_name
        concatenation = ""
        compressed = ""
        # merge common paths and specific file paths
        paths = @config["common_dependencies"] | (file_opts["dependencies"] || [] << File.expand_path(t_file.dirname.to_s))
        # prepend paths with common_path
        if @config["common_path"]
          paths.each_with_index do |n, i|
            paths[i] = @config["common_path"] + n;
          end
        end
        # source file[s]
        sources = [] << File.expand_path(file_full_path)
        # do magic
        if file_opts["type"] == "css" or file_opts["extension"] == "css"
          content = File.read(file_full_path)
          # convert sass to css
          sass = ::Sass::Engine.new(content, :load_paths => paths, :style => (file_opts["style"] && file_opts["style"].to_sym) || :expanded)
          concatenation = sass.render
        else
          # sprockets
          secretary = ::Sprockets::Secretary.new(
            :load_path    => paths,
            :source_files => sources
          )
          concatenation = secretary.concatenation.to_s
        end
        # compress
        if @config["compress"] and file_opts["compress"].nil? or file_opts["compress"]
          if file_opts["type"] == "css" or file_opts["extension"] == "css"
            # compress css
            if @config["standalone"]
              temp = Tempfile.new("cjoiner.css") << concatenation
              temp.close
              puts = "java -jar #{@config['yui']} --charset #{@config['charset']} --type css #{temp.path}"
              compressed = `java -jar #{@config["yui"]} --charset #{@config["charset"]} --type css #{temp.path}`
            else
              compressor = ::YUI::CssCompressor.new
              compressed = compressor.compress(concatenation)
            end
          else
            if @config["standalone"]
              temp = Tempfile.new("cjoiner.js") << concatenation
              munge = !@config["munge"] ? "--nomunge" : ""
              temp.close
              compressed = `java -jar #{@config["yui"]} #{munge} --charset #{@config["charset"]} --type js #{temp.path}`
            else
              compressor = ::YUI::JavaScriptCompressor.new(:munge => @config["munge"], :charset => @config["charset"])
              compressed = compressor.compress(concatenation)
            end
          end
        end
        if @config["debug"]
          d_file.open("w") { |io| io.puts concatenation }
        end
        t_file.open("w") { |io| io.puts compressed != "" ? compressed : concatenation}
        # set custom output
        if file_opts["output"] or @config["common_output"]
          output = ""
          if @config["common_output"]
            output = @config["common_output"]
          end
          if file_opts["output"]
            output += file_opts["output"]
          end
          FileUtils.mv(t_file, output + output_name)
          if @config["debug"]
            FileUtils.mv(d_file, output + debug_name)
          end
        end
      end
    end

    #init the configuration
    def initialize(config = {})
      @config =
      {
        "yui"          => 'yuicompressor-2.4.7.jar',
        "munge"        => true,
        "charset"      => 'utf-8',
        "standalone"   => false,
        "debug"        => false,
        "debug_suffix" => 'debug',
        "common_path"  => ''
      }.merge(config)
    end
  end
end
