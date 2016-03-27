require 'yaml'
require 'open3'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'coveralls/rake/task'

Coveralls::RakeTask.new

RSpec::Core::RakeTask.new(:spec)

def invoke(version, cmd)
  Bundler.with_clean_env do
    system({ 'AR' => version, 'SKIPCOV' => '1' }, cmd)
  end
end

desc 'Run against a specific ActiveRecord version'
task 'spec:version', [:version] do |_, args|
  if args.version.nil? || args.version.empty?
    abort 'No version given'
  end

  FileUtils.rm_rf 'Gemfile.lock'
  invoke args.version, 'bundle install --quiet'
  invoke args.version, 'bundle exec rspec -f progress' if $?.success?
  $stderr.puts "#{args.version} failed." unless $?.success?
end

desc 'Run against all ActiveRecord versions'
task 'spec:matrix' do
  travis = YAML.load_file '.travis.yml'
  spec_task = Rake::Task['spec:version']

  travis['env']['matrix'].each do |matrix|
    spec_task.invoke matrix[/\=(.+)$/, 1]
    spec_task.reenable
    puts "\n\n"
  end
end

task default: :spec
