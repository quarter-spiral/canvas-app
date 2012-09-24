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
  gem 'datastore-backend', '0.0.4'

  gem 'rack-test'
  gem 'rack-client'
  gem 'json'
  gem 'rake'

  platforms :rbx do
    gem 'bson_ext'
  end
end
