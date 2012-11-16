#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
end

task :default => :test

require 'qless/tasks'
namespace :qless do
  task :setup do
    require 'canvas-app' # to ensure all job classes are loaded

    # Set options via environment variables
    # The only required option is QUEUES; the
    # rest have reasonable defaults.
    ENV['REDIS_URL'] ||= ENV['MYREDIS_URL'] || 'redis://localhost:6379'
    ENV['QUEUES'] ||= 'jobs'
    ENV['JOB_RESERVER'] ||= 'Ordered'
    ENV['INTERVAL'] ||= '10' # 10 seconds
    ENV['VERBOSE'] ||= 'true'
  end
end
