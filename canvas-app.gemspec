# -*- encoding: utf-8 -*-
require File.expand_path('../lib/canvas-app/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Thorben Schröder"]
  gem.email         = ["info@thorbenschroeder.de"]
  gem.description   = %q{An app to deliver the games}
  gem.summary       = %q{An app to deliver the games}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "canvas-app"
  gem.require_paths = ["lib"]
  gem.version       = Canvas::App::VERSION

  gem.add_dependency 'uuid'
  gem.add_dependency 'sinatra', '1.3.3'
  gem.add_dependency 'sinatra-assetpack', '0.0.11'
  gem.add_dependency 'sass', '3.2.1'
  gem.add_dependency 'devcenter-backend', '0.0.1'
end
