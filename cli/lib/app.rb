require "stringio"
require "optparse"
require "json"
require "ostruct"

class App
  attr_accessor :creds, :potato, :hide_io

  def initialize
    @logger = $stdout
  end

  def self.run
    App.new.run(*ARGV)
  end

  def whoami
    creds.name
  end

  def creds
    @creds ||= begin
      creds = Creds.new
      creds.path = config.conf_location
      creds
    end
  end

  def help
    <<-EOS
Usage:
  ./run subcommand
    subcomands:
      help (default)
      whoami

EOS
  end

  def run(*args)
    @args = args.freeze

    Runner.new(@hide_io) do |io|
      @logger = io
      send(subcommand || :help)
    end
  end

  def subcommand
    p = OptionParser.new do |opts|
      opts.on("-t") do
        config.test_flag_set = true
      end

      opts.on("--creds-file FILE") do |creds_file|
        config.conf_location = creds_file
      end

      config.option_parser = opts
    end

    opts = {}
    cmds = p.parse(@args, into: opts)
    config.raw_commands = cmds
    config.raw_options = opts
    config.raw_argv = @args
    cmd = cmds.first
    cmd ||= "help"
    raise "#{cmd} is not a subcommand" unless ["whoami", "help"].include?(cmd)
    cmd
  end

  def config
    @config ||= OpenStruct.new(
      {
        conf_location: "~/.cpci.conf"
      }
    )
  end

  class Runner
    def initialize(hide_io, &bloc)
      @io = hide_io ? StringIO.new : $stdout
      @value = bloc.call(@io)
      @io.puts(@value)
    end

    def stdout
      @io.string
    end
  end
end

class NotLoggedInException < StandardError
end

class Creds
  attr_accessor :path
  def name
    found_name = creds["name"]
    raise NotLoggedInException.new unless found_name
    found_name
  end

  def creds
    raise "set path!" unless path
    creds_path = path
    JSON.parse(File.read(creds_path))
  end
end
