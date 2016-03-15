$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'bundler/setup'
Bundler.require :test

SimpleCov.formatter =
  if ENV['CI']
    SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  elsif ENV['COVERAGE']
    SimpleCov::Formatter::HTMLFormatter
  else
    SimpleCov::Formatter::Console
  end

SimpleCov.start { add_filter 'spec/' }

require 'baby_squeel'

require 'support/schema'
require 'support/models'
require 'support/matchers'

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
