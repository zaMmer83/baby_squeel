$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'
SimpleCov.start do
  add_filter 'spec/'
end

require 'baby_squeel'

RSpec.configure do |config|
  config.filter_run focus: true

  if ActiveRecord::VERSION::STRING <= '4.2.0'
    config.filter_run_excluding :post_ar42
  else
    config.filter_run_excluding :pre_ar42
  end

  config.run_all_when_everything_filtered = true
end

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

require_relative 'support/schema'
require_relative 'support/models'
require_relative 'support/matchers'
require_relative 'support/shared_examples'
