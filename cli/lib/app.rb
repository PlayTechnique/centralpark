require "stringio"

class App
  attr_accessor :creds, :potato, :hide_io

  def self.run
    App.new.run(ARGV)
  end

  def whoami
    @creds.name
  end

  def run(*args)
    # parse options and find command
    # run command
    Runner.new(@hide_io) { |io| io.puts("--help") }
  end

  class Runner
    def initialize(hide_io, &bloc)
      @io = hide_io ? StringIO.new : STDOUT
      bloc.call(@io)
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
    creds_path = path || "~/.cpci.conf"
    JSON.parse(File.read(creds_path))
  end
end
