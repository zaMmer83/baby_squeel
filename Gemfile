source 'https://rubygems.org'

# Specify your gem's dependencies in baby_squeel.gemspec
gemspec

gem 'pry'
gem 'coveralls', require: false

if ar_version = ENV['AR']
  gem 'activerecord', "~> #{ar_version}"
else
  gem 'activerecord', github: 'rails/rails'
end
