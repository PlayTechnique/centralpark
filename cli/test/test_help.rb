require "app"
require "test_helper"

describe "help" do
  before do
    @app = FactoryBot.build(:app)
  end

  it "prints help with no args" do
    cmd = @app.run
    assert_includes(cmd.stdout, "Usage")
    assert_includes(cmd.stdout, "help (default)")
  end

  it "prints help with no args from cli" do
    out = `./run`
    assert_includes(out, "Usage")
    assert_includes(out, "help (default)")
  end
end
