require "base64"
require "factory_bot"
require "fileutils"
require "json"

FactoryBot.define do
  factory(:creds) do
    path do
      p = File.join("./test/.tmp", Base64.encode64("#{Random.rand}").chomp)
      FileUtils.mkdir_p(p)
      p = File.join(p, ".creds")
      p.to_s
    end

    with_random_name

    trait(:with_random_name) do
      transient do
        name { ["ron", "harry", "hermione", "snape", "hagrid"].sample }
      end

      after(:build) do |creds, evaluator|
        f = File.new(creds.path, "w")
        f.write({name: evaluator.name}.to_json)
        f.close
      end
    end

    trait(:without_name) { name {  } }
  end

  factory(:app) do
    creds
    hide_io { true }
  end
end
