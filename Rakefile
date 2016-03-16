require 'yaml'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'coveralls/rake/task'

Coveralls::RakeTask.new

RSpec::Core::RakeTask.new(:spec)

def run_version(version, cmd)
  display = "AR=#{version} #{cmd}"
  puts display

  Bundler.with_clean_env do
    system({ 'AR' => version }, cmd)
  end

  abort "\nFAILED: #{display}" unless $CHILD_STATUS.success?
end

task 'spec:matrix' do
  travis = YAML.load_file '.travis.yml'

  travis['env']['matrix'].reverse.each do |variable|
    version = variable[/\=(.+)$/, 1]
    rm_rf 'Gemfile.lock'
    run_version version, 'bundle install > /dev/null'
    run_version version, 'rake spec'
  end
end

task default: :spec
