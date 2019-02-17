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

git 'https://github.com/gregmolnar/ransack', branch: 'fix-polymorphic-joins' do
  gem 'polyamorous'
end

gem 'bump'

group :test do
  gem 'pry'
  gem 'coveralls'
  gem 'simplecov'
  gem 'filewatcher'
end
