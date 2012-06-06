# -*- encoding: utf-8 -*-
require File.expand_path('../lib/guard/rackup/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["uu59"]
  gem.email         = ["k@uu59.org"]
  gem.description   = %q{Alternative of shotgun that built on guard}
  gem.summary       = %q{Alternative of shotgun that built on guard}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "guard-rackup"
  gem.require_paths = ["lib"]
  gem.version       = Guard::Rackup::VERSION
end
