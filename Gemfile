source 'https://rubygems.org'

# Specify your gem's dependencies in baby_squeel.gemspec
gemspec

case ENV.fetch('AR', 'latest')
when 'latest'
  gem 'activerecord'
when 'master'
  gem 'activerecord', github: 'rails/rails'
else
  gem 'activerecord', ENV['AR']
end

gem 'bump'
gem 'join_dependency', github: 'rzane/join_dependency'

group :test do
  gem 'pry'
  gem 'coveralls'
  gem 'simplecov'
  gem 'filewatcher'
end
