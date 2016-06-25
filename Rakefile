require 'yaml'
require 'open3'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'coveralls/rake/task'

Coveralls::RakeTask.new

RSpec::Core::RakeTask.new(:spec)

def invoke(env, cmd)
  Bundler.with_clean_env do
    system({ 'SKIPCOV' => '1' }.merge(env), cmd)
  end
end

def test_version(env)
  puts "-----------------------"
  puts env.inspect
  puts "-----------------------"
  FileUtils.rm_rf 'Gemfile.lock'
  invoke env, 'bundle install --quiet'
  invoke env, 'bundle exec rspec -f progress' if $?.success?
  $stderr.puts "#{env} failed." unless $?.success?
  puts "\n\n"
end

desc 'Run against all ActiveRecord versions'
task 'spec:matrix' do
  travis = YAML.load_file '.travis.yml'

  envs = travis['env']['matrix'].map do |build|
    Hash[build.split(/=|\s+/).each_slice(2).to_a]
  end

  envs.each { |env| test_version(env) }
end

task default: :spec
