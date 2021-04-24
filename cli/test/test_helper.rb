require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use!(
  [
    Minitest::Reporters::DefaultReporter.new(:color => true)
  ]
)

require "factories/all"
