# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'baby_squeel/version'

Gem::Specification.new do |spec|
  spec.name          = 'baby_squeel'
  spec.version       = BabySqueel::VERSION
  spec.authors       = ['Ray Zane']
  spec.email         = ['ray@promptworks.com']

  spec.summary       = 'A tiny squeel implementation without all of the evil.'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/rzane/baby_squeel'
  spec.license       = 'MIT'

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.add_dependency 'activerecord', '>= 4.0.0'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4.0'
  spec.add_development_dependency 'sqlite3'
end
