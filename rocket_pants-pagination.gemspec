# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rocket_pants/pagination/version'

Gem::Specification.new do |spec|
  spec.name          = 'rocket_pants-pagination'
  spec.version       = RocketPants::Pagination::VERSION
  spec.authors       = ['Alessandro Desantis']
  spec.email         = ['desa.alessandro@gmail.com']

  spec.summary       = %q{Pagination support for RocketPants.}
  spec.homepage      = 'https://github.com/alessandro1997/rocket_pants-pagination'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rocket_pants', '~> 1.13'
  spec.add_dependency 'will_paginate', '~> 3.0'
  spec.add_dependency 'active_model_serializers', '~> 0.9'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'fuubar'
end
