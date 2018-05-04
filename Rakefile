require 'yaml'
require 'open3'
require 'filewatcher'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'coveralls/rake/task'
require 'bump/tasks'

Coveralls::RakeTask.new

RSpec::Core::RakeTask.new(:spec)

def invoke(env, cmd)
  Bundler.with_clean_env do
    system({ 'SKIPCOV' => '1' }.merge(env), cmd)
  end
end

def format_version(env, failed: false)
  vars = env.map { |k, v| "#{k}=#{v}" }
  msg = "=== #{vars.join(' ')} "
  msg << 'failed ' if failed
  msg << '=' * (80 - msg.length)
end

def bundle_install(env)
  FileUtils.rm_rf 'Gemfile.lock'
  invoke env, 'bundle check --quiet > /dev/null || bundle install --quiet'
end

def version_passes?(env)
  puts format_version(env)
  bundle_install(env)
  invoke env, 'bundle exec rspec -f progress' if $?.success?
  $?.success?
end

desc 'Switch ActiveRecord version'
task :switch, [:version] do |_, args|
  abort 'No version specified.' unless args[:version]
  bundle_install 'AR' => args[:version]
  puts "export AR=#{args[:version]}"
end

desc 'Run against all ActiveRecord versions'
task 'spec:matrix' do
  travis = YAML.load_file '.travis.yml'

  envs = travis['env']['matrix'].map do |build|
    Hash[build.split(/=|\s+/).each_slice(2).to_a]
  end

  envs.each do |env|
    unless version_passes? env
      abort format_version(env, failed: true)
    end
  end
end

desc 'Watch for changes and rerun specs'
task 'spec:watch' do
  puts 'Watching...'
  Filewatcher.new(['lib', 'spec']).watch do |filename|
    Bundler.with_clean_env do
      if filename =~ /_spec\.rb$/
        system "bundle exec rspec #{filename}"
      else
        system 'bundle exec rspec'
      end
    end
  end
end

Bump::Bump::BUMPS.each do |bump|
  desc "Increment #{bump} and release"
  task "release:#{bump}" => "bump:#{bump}" do
    # we can't just run this as a prereq, because gem_tasks
    # loads the version when rake loads
    Bundler.with_clean_env do
      sh 'bundle exec rake release'
    end
  end
end

task default: :spec
