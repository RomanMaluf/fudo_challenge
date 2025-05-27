# frozen_string_literal: true

require 'rack'
require 'json'

class FudoChallenge
  def call(env)
    req = Rack::Request.new(env)

    case req.path_info
    when '/AUTHORS'
      serve_file('AUTHORS', 'text/plain', 'public, max-age=86400') if req.get?
    else
      [404, { 'content-type' => 'application/json' }, [{ error: 'Not Found' }.to_json]]
    end
  end

  def serve_file(path, content_type, cache_control)
    content = File.read(path)
    [
      200,
      {
        'content-type' => content_type,
        'cache-control' => cache_control
      },
      [content]
    ]
  end
end
