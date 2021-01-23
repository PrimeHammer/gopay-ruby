# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gopay/version'

Gem::Specification.new do |spec|
  spec.name          = "gopay-ruby"
  spec.version       = GoPay::Version
  spec.authors       = ["David Hrachovy & Ondrej Zadnik"]
  spec.email         = ["david.hrachovy@gmail.com"]
  spec.summary       = %q{Unofficial wrapper for GoPay REST API}
  spec.description   = %q{Unofficial wrapper for GoPay REST API}
  spec.homepage      = "https://github.com/PrimeHammer/gopay-ruby"
  spec.required_ruby_version = '>= 2.5'
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_development_dependency "bundler"
  spec.add_dependency 'rest-client', '~> 2.1.0'
end
