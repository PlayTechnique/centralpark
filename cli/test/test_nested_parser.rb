require "nested_parser"
require "test_helper"

describe "OptParseX" do
  it "joins parsers" do
    p1 = OptParseX.new do |opts|
      opts.on("-t", "--test")
    end

    p2 = OptParseX.new do |opts|
      opts.on("-r", "--run")
    end

    p1.parse("-t")
    p2.parse("-r")

    assert_raises(OptionParser::InvalidOption) do
      p2.parse("-x")
    end

    pp = p1.merge(p2)
    pp.parse("-t", "-r")

    assert_raises(OptionParser::InvalidOption) do
      pp.parse("-t", "-r", "-x")
    end
  end

  it "bloc runs" do
    a = 5

    p1 = OptParseX.new do |opts|
      opts.on("-t", "--test") do
        a = 10
      end
    end

    p1.parse("-t", "banana")
    assert_equal(10, a)
  end

  it "splits args from options" do
    p1 = OptParseX.new do |opts|
      opts.on("-t", "--test")
    end

    parsed = p1.parse("-t", "banana")
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

    pp = p1.merge(p2)
    parsed = pp.parse("-t", "banana", "-r")
    assert_equal(["banana"], parsed.args)
    assert_equal({:test => true, :run => true}, parsed.opts)
  end

  it "merges multiple times" do
    p1 = OptParseX.new { |opts| opts.on("-a") }
    p2 = OptParseX.new { |opts| opts.on("-b") }
    p3 = OptParseX.new { |opts| opts.on("-c") }

    pp = p1.merge(p2, p3)
    parsed = pp.parse("-a", "-b", "hi", "-c")
    assert_equal(["hi"], parsed.args)
    assert_equal({:a => true, :b => true, :c => true}, parsed.opts)

    pp = p1.merge(p2).merge(p3)
    parsed = pp.parse("-a", "-b", "hi", "-c")
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

    pp = p1.merge(p2, p3)
    parsed = pp.parse("-a", "-b", "the_option", "the_arg", "-c", "-d")
    assert_equal(["the_arg"], parsed.args)
    assert_equal({:a => true, :b => "the_option", :c => true, :dry_run => true}, parsed.opts)
  end
end
