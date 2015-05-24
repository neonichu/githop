# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'githop/version'

Gem::Specification.new do |spec|
  spec.name          = "githop"
  spec.version       = GitHop::VERSION
  spec.authors       = ["Boris Bügling"]
  spec.email         = ["boris@buegling.com"]
  spec.summary       = %q{Uses BigQuery and GitHub Archive to create something like TimeHop for GitHub.}
  spec.homepage      = "https://github.com/neonichu/githop"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'activesupport'
  spec.add_dependency 'bigquery'
end
