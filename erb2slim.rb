#!/usr/bin/env ruby

require 'optparse'
require 'find'
require 'fileutils'
require 'pry'

class Options
  attr_accessor :path

  def initialize
    options_parser = OptionParser.new do |opts|

      @path = 'app/views/'
      opts.on("-p PATH") do |path|
        @path = path
      end

      @cleanup = false
      opts.on("-c") do
        @cleanup = true
      end

      @skip_convert = false
      opts.on("-C") do
        @cleanup = true
        @skip_convert = true
      end

    end

    options_parser.parse!
  end

  def on(symbol)

    if symbol == :convert && @skip_convert != true
      yield
    end

    if symbol == :cleanup && @cleanup
      yield
    end

  end

end

class Program
  RED_FG ="\033[31m"
  GREEN_FG = "\033[32m"
  END_TEXT_STYLE = "\033[0m"

  attr_reader :erb_files, :haml_files, :options

  def initialize(options)
    @options = options
  end

  def run
    @options.on :convert do
      validate
      gather
      convert
    end

    @options.on :cleanup do
      cleanup
    end
  end

  private

    def validate
      if `which html2haml`.empty?
        puts "#{color "ERROR: ", RED_FG} Could not find " +
          "#{color "html2haml", GREEN_FG} in your PATH. Aborting."
        exit(false)
      end
    end

    def gather
      puts "Gathering ERB files to convert..."
      @erb_files = find(@options.path, /\.html\.erb$/i)
    end

    def convert
      if @erb_files.empty?
        puts "Nothing to convert."
        return
      end

      puts "Converting #{color "ERB", GREEN_FG} files " +
        "to #{color "Slim", RED_FG}..."
      convert_erb_to_haml
      convert_haml_to_slim
      puts "Complete."
    end

    def find(search_path, pattern)
      files = []
      Find.find(search_path) do |path|
        if FileTest.file?(path) && path.downcase.match(pattern)
          files << path
        end
      end
      files
    end

    def convert_erb_to_haml
      @haml_files = []
      @erb_files.each do |path|

        haml_path = path.slice(0...-3)+"haml"

        unless FileTest.exists?(haml_path)
          system("html2haml", path, haml_path)
        end
        @haml_files << haml_path
      end
    end

    def convert_haml_to_slim
      @haml_files.each do |path|
        slim_path = path.slice(0...-4)+"slim"
        unless FileTest.exists?(slim_path)
          Haml2Slim.convert! path
        end
      end
    end

    def cleanup
      puts "Cleaning up files..."

      erb_files = find(@options.path, /\.html\.erb$/i)
      haml_files = find(@options.path, /\.html\.haml$/i)

      remove_files(erb_files)
      remove_files(haml_files)
    end

    def remove_files(files)
      files.each do |path|
        FileUtils.rm(path) if FileTest.exists?(path)
      end
    end

    # Helper method to inject ASCII escape sequences for colorized output
    def color(text, begin_text_style)
      begin_text_style + text + END_TEXT_STYLE
    end
end

options = Options.new
program = Program.new(options)
program.run

