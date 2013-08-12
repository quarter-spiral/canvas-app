source 'https://rubygems.org'
source "https://user:We267RFF7BfwVt4LdqFA@privategems.herokuapp.com/"

# Specify your gem's dependencies in canvas-app.gemspec
gemspec

#gem 'service-client', path: '../service-client'

#gem 'datastore-client', path: '../datastore-client'

#gem 'graph-client', path: '../graph-client'

#gem 'devcenter-backend', path: '../devcenter-backend'

#gem 'facebook-client', path: '../facebook-client'

#gem 'auth-client', path: '../auth-client'

#gem 'playercenter-client', path: '../playercenter-client'

platforms :ruby do
  gem 'thin'
end

gem 'qless', git: "https://github.com/seomoz/qless.git", ref: '8e2917be640cfa31cef70acbdd45abf73a5fe1ff', submodules: true

group :test, :development do
  gem 'datastore-backend', '~> 0.0.19'
  #gem 'datastore-backend', path: '../datastore-backend'

  gem 'rack-test'
  gem 'rack-client'
  gem 'json'
  gem 'rake'

  gem 'graph-client', '~> 0.0.13'
  gem 'graph-backend', '~> 0.0.26'
  #gem 'graph-backend', path: '../graph-backend'
  gem 'auth-backend', "~> 0.0.33"
  #gem 'auth-backend', path: '../auth-backend'
  gem 'sdk-app', "~> 0.0.12"
  gem 'sqlite3'
  gem 'sinatra_warden', git: 'https://github.com/quarter-spiral/sinatra_warden.git'
  gem 'songkick-oauth2-provider', git: 'https://github.com/quarter-spiral/oauth2-provider.git'
  gem 'nokogiri'

  gem 'playercenter-backend', '~> 0.0.29'
  #gem 'playercenter-backend', path: '../playercenter-backend'
  gem 'spiral-galaxy', '>= 0.0.31'
  #gem 'spiral-galaxy', path: '../spiral-galaxy'

  gem 'poltergeist'
  gem 'capybara'
  gem 'launchy'
  gem 'capybara_minitest_spec'

  platforms :rbx do
    gem 'bson_ext'
  end
end
