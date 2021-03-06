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
  gem.add_dependency 'devcenter-backend', '>=0.0.50'
  gem.add_dependency 'datastore-client', '>=0.0.12'
  gem.add_dependency 'auth-client', '>= 0.0.17'
  gem.add_dependency 'playercenter-client', '0.0.5'
  gem.add_dependency 'facebook-client', '>= 0.0.5'
  gem.add_dependency 'coffee-script', '2.2.0'
  gem.add_dependency 'less', '2.2.2'
  gem.add_dependency 'therubyracer', '0.10.2'

  #gem.add_dependency 'qless', '>= 0.9.2'
  gem.add_dependency 'angular-commons-middleware'
  gem.add_dependency 'uglifier'
  gem.add_dependency 'newrelic_rpm'
  gem.add_dependency 'ping-middleware', '~> 0.0.2'
  gem.add_dependency 'omniauth-oauth2'

  gem.add_dependency 'tracking-client', '~> 0.0.6'

  gem.add_dependency 'cache-client', '~> 0.0.4'
  gem.add_dependency 'cache-backend-iron-cache', '~> 0.0.4'

  gem.add_dependency 'qs-request-tracker', '>= 0.0.2'
  gem.add_dependency 'sentry-raven'
end