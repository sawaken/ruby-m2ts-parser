# coding: utf-8
# -*- mode: ruby -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'm2ts_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "m2ts_parser"
  spec.version       = M2TSParser::VERSION
  spec.authors       = ["sawaken"]
  spec.email         = ["sasasawada@gmail.com"]
  spec.summary       = %q{An elegant MPEG2-TS file Parser.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "binary_parser", ">= 1.2.1"
  spec.add_dependency "tsparser", ">= 0.0.0"    
end
