# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'draw_kingdom/version'

Gem::Specification.new do |spec|
  spec.name          = "draw_kingdom"
  spec.version       = DrawKingdom::VERSION
  spec.authors       = ["Asaf Shveki"]
  spec.email         = ["asaf.shveki@autodesk.com"]
  spec.summary       = ["Summary"]
  spec.description   = ["ssss"]
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
