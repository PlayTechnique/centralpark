require "minitest/autorun"
require "minitest/reporters"
require "minitest/pride"

Minitest::Reporters.use!(
  [
    Minitest::Reporters::DefaultReporter.new(:color => true)
  ]
)

require "factories/all"
