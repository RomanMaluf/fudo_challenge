# frozen_string_literal: true

module Middlewares
  class Gzip
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)

      return [status, headers, [response]] if headers['content-encoding'] == 'gzip'

      if env['HTTP_ACCEPT_ENCODING']&.include?('gzip')
        require 'zlib' # Only require Zlib if gzip is accepted
        gzipped_body = StringIO.new
        gz = Zlib::GzipWriter.new(gzipped_body)
        response.each { |part| gz.write(part) }
        gz.close
        headers['content-encoding'] = 'gzip'
        headers['content-length'] = gzipped_body.size.to_s
        response = gzipped_body.string
        return [status, headers, [response]]
      end
      [status, headers, response]
    end
  end
end
