# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'approval2/version'

Gem::Specification.new do |spec|
  spec.name          = "approval2"
  spec.version       = Approval2::VERSION
  spec.authors       = ["akil"]
  spec.email         = ["akhilesh.kataria@quantiguous.com"]

  spec.summary       = %q{Enable the approval pattern for an AR model}
  spec.homepage      = "http://quantiguous.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "audited"
  spec.add_dependency "will_paginate"
  spec.add_dependency "unscoped_associations"
end
