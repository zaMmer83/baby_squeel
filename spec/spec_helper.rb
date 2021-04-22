# frozen_string_literal: true

require "baby_squeel"
require "irb"
require_relative "support/schema"
require_relative "support/models"
require_relative "support/match_sql"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.include MatchSQL

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
