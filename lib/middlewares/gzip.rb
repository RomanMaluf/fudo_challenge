# frozen_string_literal: true

module Middlewares
  # Middleware to handle Gzip compression when the client accepts it.
  class Gzip
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)

      return [status, headers, body] if already_gzipped?(headers) || !accepts_gzip?(env) || body.empty?

      compressed = build_gzipped_body(body)

      headers['content-encoding'] = 'gzip'
      headers['content-length'] = compressed.bytesize.to_s
      [status, headers, [compressed]]
    end

    def already_gzipped?(headers)
      headers['content-encoding'] == 'gzip'
    end

    def accepts_gzip?(env)
      env['HTTP_ACCEPT_ENCODING']&.include?('gzip')
    end

    def build_gzipped_body(body)
      require 'zlib' # Ensure Zlib is required for compression
      gzipped_body = StringIO.new
      gz = Zlib::GzipWriter.new(gzipped_body)
      body.each { |part| gz.write(part) }
      gz.close
      gzipped_body.string
    end
  end
end
