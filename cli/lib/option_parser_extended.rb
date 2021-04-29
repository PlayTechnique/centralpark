require "optparse"
require "ostruct"

class OptParseX < OptParse
  def initialize(&bloc)
    @saved_on_calls = []
    super
  end

  def on(*args, &bloc)
    super

    @saved_on_calls << OpenStruct.new({args: args, bloc: bloc})
  end

  def parsed(*args)
    opts = {}
    args = parse(*args, into: opts)
    OpenStruct.new(args: args, opts: opts)
  end

  def +(*more)
    all_sub_opt_parsers = [self, *more]

    return self.class.new do |opts|
      all_sub_opt_parsers.each do |parser|
        parser.ons.each do |on|
          opts.on(*on.args, &on.bloc)
        end
      end
    end
  end

  protected

  def ons
    @saved_on_calls
  end
end
