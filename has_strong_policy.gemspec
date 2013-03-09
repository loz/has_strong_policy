# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'has_strong_policy/version'

Gem::Specification.new do |gem|
  gem.name          = "has_strong_policy"
  gem.version       = HasStrongPolicy::VERSION
  gem.authors       = ["Jonathan Lozinski"]
  gem.email         = ["jonathan.lozinski@gmail.com"]
  gem.description   = %q{Simple params policy delegation for rails}
  gem.summary       = %q{A simple delgation framework for strong parameters}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency 'activesupport'
end
