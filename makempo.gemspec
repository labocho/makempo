# -*- encoding: utf-8 -*-
require File.expand_path('../lib/makempo/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["labocho"]
  gem.email         = ["labocho@penguinlab.jp"]
  gem.description   = %q{Make MPO file from 2 jpegs}
  gem.summary       = %q{Make MPO file from 2 jpegs}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "makempo"
  gem.require_paths = ["lib"]
  gem.version       = Makempo::VERSION

  gem.add_dependency "bindata"
end
