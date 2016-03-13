$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start { add_filter 'spec/' }

require 'baby_squeel'

require_relative 'support/schema'
require_relative 'support/models'
require_relative 'support/matchers'
require_relative 'support/shared_examples'

RSpec.configure do |config|
  config.filter_run focus: true

  config.before :suite do
    puts "\nRunning with ActiveRecord #{ActiveRecord::VERSION::STRING}"
  end

  if ActiveRecord::VERSION::STRING <= '4.2.0'
    config.filter_run_excluding :post_ar42
  else
    config.filter_run_excluding :pre_ar42
  end

  config.run_all_when_everything_filtered = true
end
