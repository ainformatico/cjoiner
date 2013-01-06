# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cjoiner/version'

Gem::Specification.new do |gem|
  gem.name          = "cjoiner"
  gem.version       = Cjoiner::VERSION
  gem.authors       = ["Alejandro El Informático"]
  gem.email         = ["aeinformatico@gmail.com"]
  gem.description   = %q{Join css and js assets and create a versioned file.}
  gem.summary       = %q{Simple tool for joining css and js assets and create a versioned file using a yaml file as configuration. Output format is 'filename.0.0.0.0.extension'}
  gem.homepage      = "https://github.com/ainformatico/cjoiner"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
