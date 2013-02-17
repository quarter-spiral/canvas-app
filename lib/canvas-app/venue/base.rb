module Canvas::App
  module Venue
    class Base
      attr_reader :game

      def initialize(game)
        @game = game
      end

      def template
        Utils.uncamelize_string(name).to_sym
      end

      def response_for(game, context, template_options = {})
        activate_local_mode_when_necessary!(game, template_options[:uuid])

        embedded_game = embedded_game(game, context, template_options)
        return context.halt(403, "Invalid game") unless embedded_game
        if embedded_game.kind_of?(Hash)
          context.status embedded_game[:status]
          return embedded_game[:body]
        end

        context.erb template, locals: template_options.merge(game: game, embedded_game: embedded_game, context: context, venue: Utils.uncamelize_string(name).gsub('_', '-'))
      end

      protected
      def embedded_game(game, context, options = {})
        embedder = Embedder.for(game)
        return unless embedder

        return {status: embedder.status, body: embedder.body} if embedder.respond_to?(:body)

        context.erb embedder.template, locals: options.merge(game: game, request: context.request), layout: false
      end

      def activate_local_mode_when_necessary!(game, uuid)
        return unless uuid
        return unless game.developer_configuration['local_mode'] && game.developer_configuration['local_mode'][uuid]

        game.configuration = game.developer_configuration['local_mode'][uuid]
      end

      def name
        self.class.name.split('::').last
      end
    end
  end
end