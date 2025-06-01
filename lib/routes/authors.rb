# frozen_string_literal: true

module Routes
  # Authors Route Handler
  class Authors
    def self.route(env)
      case env[:request_method]
      when :get
        handle_get_request
      else
        raise NotFoundError, "Unsupported method: #{env[:request_method]}"
      end
    end

    def self.handle_get_request
      ResponseBuilder.serve_file('public/AUTHORS', content_type: 'text/plain', cache_control: 'public, max-age=86400')
    end
  end
end
