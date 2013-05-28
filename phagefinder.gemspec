# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'phagefinder/version'

# so we can run gem install phagefinder --dev and have rspec and other dependencies installed
# Bundler.require(:default, :development)

Gem::Specification.new do |spec|
  spec.name          = "phagefinder"
  spec.version       = Phagefinder::VERSION
  spec.authors       = ["Simon Twigger"]
  spec.email         = ["simon@bioteam.net"]
  spec.description   = %q{A gem to facilitate dealing with Phage Finder output files}
  spec.summary       = %q{Provides some core methods for processing Phage Finder output and converting to other formats}
  spec.homepage      = "https://github.com/bioteam/phagefinder"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.6"
end
