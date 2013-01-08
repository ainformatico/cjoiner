# -*- encoding: utf-8 -*-
require "cjoiner/version"
require "cjoiner/errors"
require "cjoiner/helpers"
require "cjoiner/engine"

# system
require 'pathname'

# gems
require 'rubygems'

module Cjoiner #:nodoc
  # main class
  class Joiner
    include Cjoiner::Helpers::Files
    # load the configuration file
    def load_config!(config_file)
      @config.merge! load_yaml(config_file)["config"]
    end

    #process all the configuration
    def proccess!
      #each filename with its options
      @config["files"].each do |filename, file_opts|
        # set file path and name
        file_full_path = @config["common_path"] + filename
        full_filename  = Pathname.new(file_full_path)
        output_name    = %[#{file_opts["name"]}.#{file_opts["major"]}.#{file_opts["minor"]}.#{file_opts["bugfix"]}.#{file_opts["compilation"]}.#{file_opts["extension"]}]
        debug_name     = %[#{file_opts["name"]}.#{@config["debug_suffix"]}.#{file_opts["extension"]}]
        output_file    = full_filename.dirname + output_name
        debug_file     = full_filename.dirname + debug_name
        debug         = (@config["debug"] and file_opts["debug"].nil? or file_opts["debug"])
        custom_output = (@config["common_output"] and file_opts["output"].nil? or file_opts["output"])
        # save all the concatenation
        concatenation = ""
        # save compressed content
        compressed = ""
        # merge common paths and specific file paths
        paths = @config["common_dependencies"] | (file_opts["dependencies"] || [] << File.expand_path(output_file.dirname.to_s))
        # prepend paths with common_path
        if @config["common_path"]
          paths.each_with_index do |n, i|
            paths[i] = @config["common_path"] + n
          end
        end
        # source file[s]
        sources = [] << File.expand_path(file_full_path)
        # do magic
        if file_opts["type"] == "css" or file_opts["extension"] == "css"
          concatenation = Cjoiner::Engines::Css.new(
          {
            :content => read_file(file_full_path),
            :paths   => paths,
            :style   => file_opts["style"]
          }).render
        elsif file_opts["type"] == "js" or file_opts["extension"] == "js"
          concatenation = Cjoiner::Engines::JsJoiner.new(
          {
            :paths   => paths,
            :sources => sources
          }).render
        end
        # compress
        if @config["compress"] and file_opts["compress"].nil? or file_opts["compress"]
          compressed = Cjoiner::Engines::Compressor.new(
          {
            :type       => file_opts["extension"].to_sym,
            :yui        => @config['yui'],
            :charset    => @config['charset'],
            :content    => concatenation
          }).render
        end
        # save debug file
        if debug
          write_file debug_file, concatenation
        end
        # save final file
        write_file output_file, compressed != "" ? compressed : concatenation
        # set custom output
        if custom_output
          output = @config["common_output"] ? @config["common_output"] : ""
          output += file_opts["output"] if file_opts["output"]
          move_file output_file, output + output_name
          if debug
            move_file debug_file, output + debug_name
          end
        end
      end
    end

    #init the configuration
    def initialize(config = {})
      @config =
      {
        "yui"          => false,
        "munge"        => true,
        "charset"      => 'utf-8',
        "debug"        => false,
        "debug_suffix" => 'debug',
        "compress"     => false,
        "common_path"  => ''
      }.merge(config)
    end
  end
end
