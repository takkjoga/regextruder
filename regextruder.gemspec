# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'regextruder/version'

Gem::Specification.new do |spec|
  spec.name          = "regextruder"
  spec.version       = Regextruder::VERSION
  spec.authors       = ["onodera_takumi"]
  spec.email         = ["takkjoga@gmail.com"]

  spec.summary       = %q{generate random characters by regular expression}
  spec.description   = %q{generate random characters by regular expression}
  spec.homepage      = "https://github.com/takkjoga/regextruder"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "regexp_parser"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rubocop'
end
