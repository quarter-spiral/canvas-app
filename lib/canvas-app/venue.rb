require "canvas-app/venue/base"
require "canvas-app/venue/spiral_galaxy"
require "canvas-app/venue/facebook"
require "canvas-app/venue/embedded"

module Canvas::App
  module Venue
    def self.for(game, venue_name)
      return nil unless game.venues[venue_name]
      venue = get(venue_name)
      return nil unless venue
      venue.new(game)
    end

    protected
    def self.get(venue_name)
      const_get(Utils.camelize_string(venue_name))
    rescue NameError => e
      nil
    end
  end
end

