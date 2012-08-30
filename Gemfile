source 'https://rubygems.org'

# Specify your gem's dependencies in canvas-app.gemspec
gemspec

#gem 'service-client', path: '../service-client'
gem 'service-client', git: 'git@github.com:quarter-spiral/service-client.git', :tag => 'release-0.0.4'

#gem 'datastore-client', path: '../datastore-client'
gem 'datastore-client', git: 'git@github.com:quarter-spiral/datastore-client.git', :tag => 'release-0.0.2'

#gem 'graph-client', path: '../graph-client'
gem 'graph-client', git: 'git@github.com:quarter-spiral/graph-client.git', :tag => 'release-0.0.2'

#gem 'devcenter-backend', path: '../devcenter-backend'
gem 'devcenter-backend', git: 'git@github.com:quarter-spiral/devcenter-backend.git', :tag => 'release-0.0.1'

group :test, :development do
  #gem 'datastore-backend', path: '../datastore-backend'
  gem 'datastore-backend', git: 'git@github.com:quarter-spiral/datastore-backend.git', tag: 'release-0.0.4'

  gem 'rack-test'
  gem 'rack-client'
  gem 'json'
  gem 'rake'
end
