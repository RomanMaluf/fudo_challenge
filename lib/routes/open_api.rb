# frozen_string_literal: true

module Routes
  # OpenAPI Route Handler
  class OpenApi
    class << self
      def route(env)
        case env[:request_method]
        when :get
          handle_get_request
        else
          raise NotFoundError, "Unsupported method: #{env[:request_method]}"
        end
      end

      private

      def handle_get_request
        ResponseBuilder.serve_file('public/openapi.yaml', content_type: 'text/yaml', cache_control: 'no-cache')
      end
    end
  end
end
