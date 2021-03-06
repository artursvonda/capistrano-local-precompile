# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |gem|
  gem.name          = 'capistrano-local-precompile'
  gem.version       = CapistranoLocalPrecompile::VERSION
  gem.homepage      = 'https://github.com/spagalloco/capistrano-local-precompile'

  gem.authors       = ["Steve Agalloco", "Arturs Vonda"]
  gem.email         = 'steve.agalloco@gmail.com'
  gem.description   = 'Local asset-pipeline precompilation for Capstrano'
  gem.summary       = gem.description

  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = Dir.glob("spec/**/*")
  gem.require_paths = ['lib']

  gem.add_dependency 'capistrano', '~> 3'
end
