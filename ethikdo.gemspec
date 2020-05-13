lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'ethikdo/version'

Gem::Specification.new do |s|
  s.name          = "ethikdo"
  s.version       = Ethikdo::VERSION
  s.authors       = ["Benoit Baumann", "Kevin Chavanne"]
  s.email         = ["baumann.benoit@gmail.com", "kevin.chavanne@gmail.com"]

  s.summary       = "A ruby wrapper for Ethikdo REST API "
  s.description   = "This gem provides an easy way to manage transactions for Ethi'kdo card holders through the Ethi'kdo REST API"
  s.homepage      = "https://github.com/wedressfair/ethikdo"
  s.license       = "MIT"
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  s.metadata["homepage_uri"] = s.homepage
  s.metadata["source_code_uri"] = "https://github.com/wedressfair/ethikdo"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", "~> 3.2"
  s.add_development_dependency 'rake', '~> 13'
  s.add_development_dependency 'webmock', '~> 3'
  s.add_development_dependency 'generator_spec', '~> 0.9'
  s.add_runtime_dependency 'httparty', '~> 0.16.2'
end
