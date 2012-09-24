require "canvas-app/embedder/base"
require "canvas-app/embedder/initial"
require "canvas-app/embedder/html5"
require "canvas-app/embedder/flash"

module Canvas::App
  module Embedder
    def self.for(game)
      const_get(Utils.camelize_string(game.configuration['type'])).new(game)
    rescue NameError => e
      nil
    end
  end
end
