# frozen_string_literal: true

require 'rack/cors'

module Middlewares
  # Rack-cors middleware to handle CORS requests.
  class Cors
    def initialize(app)
      @app = app
    end

    def call(env)
      Rack::Cors.new(@app) do
        allow do
          origins '*'
          resource '*',
                   headers: :any,
                   methods: %i[get post put patch delete options head]
        end
      end.call(env)
    end
  end
end
