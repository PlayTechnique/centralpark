require "app"
require "test_helper"

describe "whoami" do
  it "says who you are" do
    @app = FactoryBot.build(:app, creds: FactoryBot.build(:creds, name: "dingus"))
    assert_equal("dingus", @app.whoami)
  end

  it "says not logged in" do
    @app = FactoryBot.build(:app, creds: FactoryBot.build(:creds, :without_name))
    assert_raises(NotLoggedInException) { @app.whoami }
  end

  it "prints name" do
    @app = FactoryBot.build(:app, creds: FactoryBot.build(:creds, name: "dingus"))
    cmd = @app.run("whoami")
    assert_includes(cmd.stdout, "dingus")
  end

  it "detects subcommand option (-t)" do
    @app = FactoryBot.build(:app, creds: FactoryBot.build(:creds, name: "dingus"))
    @app.run("whoami", "-t")
    assert(@app.config.test_flag_set)
  end

  it "respects global option (--creds-file FILE)" do
    @app = FactoryBot.build(:app, creds: nil)
    cmd = @app.run("whoami", "--creds-file", "./test/faux-creds")
    assert_includes(cmd.stdout, "roflcopter")
  end
end
