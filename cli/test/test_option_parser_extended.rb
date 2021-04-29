require "option_parser_extended"
require "test_helper"

describe "OptParseX" do
  it "can parse arguments using multiple definitions" do
    p1 = OptParseX.new do |opts|
      opts.on("-t", "--test")
    end

    p2 = OptParseX.new do |opts|
      opts.on("-r", "--run")
    end

    # each can parse their own defined option
    p1.parse("-t")
    p2.parse("-r")

    # parsing the options from another parse raises errors
    assert_raises(OptionParser::InvalidOption) do
      p2.parse("-x")
    end

    # however joining the parsers, we can parse without raising errors
    pp = p1 + p2
    pp.parse("-t", "-r")

    # don't worry, invalid option errors will continue to be raised
    assert_raises(OptionParser::InvalidOption) do
      pp.parse("-t", "-r", "-x")
    end
  end

  it "splits args from options" do
    p1 = OptParseX.new do |opts|
      opts.on("-t", "--test")
    end

    parsed = p1.parsed("-t", "banana")
    assert_equal(["banana"], parsed.args)
    assert_equal({test: true}, parsed.opts)
  end

  it "splits args from merged options" do
    p1 = OptParseX.new do |opts|
      opts.on("-t", "--test")
    end

    p2 = OptParseX.new do |opts|
      opts.on("-r", "--run")
    end

    pp = p1 + p2
    parsed = pp.parsed("-t", "banana", "-r")
    assert_equal(["banana"], parsed.args)
    assert_equal({:test => true, :run => true}, parsed.opts)
  end

  it "joining parsers in different ways (but same order) result in the same behavior" do
    p1 = OptParseX.new { |opts| opts.on("-a") }
    p2 = OptParseX.new { |opts| opts.on("-b") }
    p3 = OptParseX.new { |opts| opts.on("-c") }

    pp = p1.+(p2, p3)
    parsed = pp.parsed("-a", "-b", "hi", "-c")
    assert_equal(["hi"], parsed.args)
    assert_equal({:a => true, :b => true, :c => true}, parsed.opts)

    pp = p1.+(p2).+(p3)
    parsed = pp.parsed("-a", "-b", "hi", "-c")
    assert_equal(["hi"], parsed.args)
    assert_equal({:a => true, :b => true, :c => true}, parsed.opts)
  end

  it "merges multiple times" do
    p1 = OptParseX.new { |opts|
      opts.on("-a")
      opts.on("-d", "--dry_run")
    }

    p2 = OptParseX.new { |opts| opts.on("-bREQ") }
    p3 = OptParseX.new { |opts| opts.on("-c") }

    pp = p1 + p2 + p3
    parsed = pp.parsed("-a", "-b", "the_option", "the_arg", "-c", "-d")
    assert_equal(["the_arg"], parsed.args)
    assert_equal({:a => true, :b => "the_option", :c => true, :dry_run => true}, parsed.opts)
  end
end
