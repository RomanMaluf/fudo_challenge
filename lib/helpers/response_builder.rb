# frozen_string_literal: true

class ResponseBuilder
  class << self
    def build(status, body:, headers: {})
      # Downcase all header keys to comply with Rack requirements
      downcased_headers = headers.transform_keys { |k| k.to_s.downcase }
      [status, downcased_headers.merge('content-type' => 'application/json'), [body.to_json]]
    end

    def serve_file(path, content_type: 'application/json', cache_control: 'no-cache')
      content = File.read(path)
      build(200, body: content, headers: { 'content-type' => content_type, 'cache-control' => cache_control })
    end
  end
end
