# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-patches/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-patches"
  spec.version       = Vagrant::Patches::VERSION
  spec.authors       = ["Felix Gilcher"]
  spec.email         = ["felix.gilcher@asquera.de"]
  spec.summary       = %q{A collection of various patches that have not yet been accepted to vagrant}
  spec.description   = %q{A collection of patches for vagrant that have not yet been accepted. Includes fixes for box downloading and CentOS 7}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
