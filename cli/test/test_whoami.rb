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
end
