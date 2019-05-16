# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mina/proteus/version'

Gem::Specification.new do |spec|
  spec.name          = "mina-proteus"
  spec.version       = Mina::Multistage::VERSION
  spec.authors       = ["apontini"]
  spec.email         = ["alberto.pontini@gmail.com"]
  spec.description   = %q{Adds multistage and multiapps capabilities to Mina, specifically built for Hanami ruby framework}
  spec.summary       = %q{Adds multistage and multiapps capabilities to Mina, specifically built for Hanami ruby framework}
  spec.homepage      = "http://github.com/apontini/mina-proteus"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mina", "~> 1.0"
  spec.add_development_dependency "bundler", ">= 1.3.5"
  spec.add_development_dependency "rake"
end
