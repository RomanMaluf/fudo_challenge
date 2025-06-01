# frozen_string_literal: true

class ResponseBuilder
  class << self
    def build(status, body:, headers: {})
      [status, build_headers(headers), [build_body(body)]]
    end

    def serve_file(path, content_type: 'application/json', cache_control: 'no-cache')
      content = File.read(path)
      build(200, body: content, headers: { 'content-type' => content_type, 'cache-control' => cache_control })
    end

    private

    def build_headers(headers)
      # Downcase all header keys to comply with Rack requirements
      headers.transform_keys { |k| k.to_s.downcase }.merge(
        'access-control-allow-origin' => '*',
        'access-control-allow-headers' => 'authorization, content-type',
        'access-control-allow-methods' => 'GET, POST, PUT, DELETE, OPTIONS',
        'x-powered-by' => 'FudoChallenge',
        'server' => 'FudoChallengeServer'
      )
      headers['content-type'] ||= 'application/json' # Default content type if not provided
      headers
    end

    def build_body(body)
      body.is_a?(String) ? body : body.to_json
    end
  end
end
