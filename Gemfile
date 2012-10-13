source 'https://rubygems.org'
source "https://user:We267RFF7BfwVt4LdqFA@privategems.herokuapp.com/"

# Specify your gem's dependencies in canvas-app.gemspec
gemspec

#gem 'service-client', path: '../service-client'

#gem 'datastore-client', path: '../datastore-client'

#gem 'graph-client', path: '../graph-client'

#gem 'devcenter-backend', path: '../devcenter-backend'

platforms :ruby do
  gem 'thin'
end

group :test, :development do
  #gem 'datastore-backend', path: '../datastore-backend'
  gem 'datastore-backend', '0.0.9'

  gem 'rack-test'
  gem 'rack-client'
  gem 'json'
  gem 'rake'

  gem 'graph-client', '0.0.5'
  #gem 'graph-backend', path: '../graph-backend'
  gem 'graph-backend', '0.0.9'
  gem 'auth-backend', "~> 0.0.6"
  gem 'sqlite3'
  gem 'sinatra_warden', git: 'https://github.com/quarter-spiral/sinatra_warden.git'
  gem 'songkick-oauth2-provider', git: 'https://github.com/quarter-spiral/oauth2-provider.git'
  gem 'nokogiri'

  platforms :rbx do
    gem 'bson_ext'
  end
end
