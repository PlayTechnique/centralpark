require "app"
require "test_helper"

describe "runner" do
  it "prints name" do
    @app = FactoryBot.build(:app)
    cmd = @app.run("runner", "foo", "--dry-run", "bar")
    assert_includes(cmd.stdout, "foo")
    assert_includes(cmd.stdout, "bar")
    refute_includes(cmd.stdout, "dry")
  end

  it "distinguishes arguments from global option arguments" do
    @app = FactoryBot.build(:app)
    cmd = @app.run("runner", "--creds-file", "some_creds_file", "foo", "--dry-run", "bar")
    assert_includes(cmd.stdout, "foo")
    assert_includes(cmd.stdout, "bar")
    refute_includes(cmd.stdout, "dry")
    refute_includes(cmd.stdout, "some_creds_file")
  end
end
