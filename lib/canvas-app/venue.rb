require "canvas-app/venue/base"
require "canvas-app/venue/galaxy_spiral"
require "canvas-app/venue/facebook"

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

