# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redistributor/version'

Gem::Specification.new do |spec|
  spec.name          = "redistributor"
  spec.version       = Redistributor::VERSION
  spec.authors       = ["Alejandro León"]
  spec.email         = ["alejandro.leon@the-cocktail.com"]
  spec.description   = %q{Distributes redis commands between master and slave}
  spec.summary       = %q{Distributes redis commands between master and slave}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "redis", "~> 3.0.7"
  spec.add_dependency "redis-namespace", "~> 1.4.1"
  spec.add_dependency "activesupport", ">= 3.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency "mock_redis", "~> 0.11.0"

end
