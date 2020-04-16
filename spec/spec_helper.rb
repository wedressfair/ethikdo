lib = File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "bundler/setup"
require "ethikdo"
require "generator_spec"
require 'generators/ethikdo/install_generator'

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end
end

unless defined?(SPEC_ROOT)
  SPEC_ROOT = File.expand_path('../', __FILE__)
end

Dir[File.join(SPEC_ROOT, 'support/**/*.rb')].each { |f| require f }
