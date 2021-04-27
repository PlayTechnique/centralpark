require "optparse"
require "ostruct"

class OptParseX
  attr_reader :ons
  def initialize(&bloc)
    @ons = []
    @opt_arse = OptParse.new(&bloc)
    bloc.call(self)
  end

  def on(*args, &bloc)
    @ons << OpenStruct.new({args: args, bloc: bloc})
  end

  def parse(*args)
    opts = {}
    args = @opt_arse.parse(*args, into: opts)
    OpenStruct.new(args: args, opts: opts)
  end

  def merge(*more)
    all_sub_opt_parsers = [self, *more]

    return self.class.new do |opts|
      all_sub_opt_parsers.each do |parser|
        parser.ons.each do |on|
          opts.on(*on.args, &on.bloc)
        end
      end
    end
  end
end
