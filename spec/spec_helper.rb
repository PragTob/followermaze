require 'simplecov'
SimpleCov.start do
  add_filter 'spec/'
end

require 'rspec/its'
require_relative 'helpers/tcp'
require_relative 'helpers/async_helper'
require_relative 'follow_me/event/shared_context'

require_relative '../lib/sorted'
require_relative '../lib/follow_me'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random
  config.disable_monkey_patching!
end
