module Canvas
  module App
    ROOT = File.expand_path('./', File.dirname(__FILE__))
  end
end

require "qless"

require "facebook-client"

require "datastore-client"
require "playercenter-client"
require "devcenter-backend"

require "canvas-app/version"
require "canvas-app/utils"
require "canvas-app/job"
require "canvas-app/embedder"
require "canvas-app/venue"
require "canvas-app/connection"
require "canvas-app/app"
