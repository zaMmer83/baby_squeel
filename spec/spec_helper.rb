$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'bundler/setup'
Bundler.require :test

SimpleCov.formatter =
  if ENV['CI']
    SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  else
    SimpleCov::Formatter::HTMLFormatter
  end

SimpleCov.start { add_filter 'spec/' }

require 'baby_squeel'

require 'support/schema'
require 'support/models'
require 'support/matchers'

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.before :suite do
    puts "\nRunning with ActiveRecord #{ActiveRecord::VERSION::STRING}"
  end
end
