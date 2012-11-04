# -*- encoding: utf-8 -*-
require File.expand_path('../lib/presenta/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Erol Fornoles"]
  gem.email         = ["erol.fornoles@gmail.com"]
  gem.description   = %q{Framework-agnostic presenters for Ruby entities and models}
  gem.summary       = %q{Framework-agnostic presenters for Ruby entities and models}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "presenta"
  gem.require_paths = ["lib"]
  gem.version       = Presenta::VERSION

  gem.add_development_dependency 'minitest'
end
