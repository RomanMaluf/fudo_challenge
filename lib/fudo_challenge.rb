# frozen_string_literal: true

require 'rack'
require 'json'
require 'digest/md5'
require 'securerandom'

# Custom Error Classes
require_relative 'errors/not_found_error'
require_relative 'errors/unauthorized_error'

# Helpers
require_relative 'helpers/response_builder'

# Routes
require_relative 'routes/auth'
require_relative 'routes/products'
require_relative 'routes/jobs'

# Jobs
require_relative 'jobs/insert_product'

# Models
require_relative 'models/product'
class FudoChallenge
  API_TOKEN = 'fudo_challenge_api_token'

  def call(env)
    process_route(env)
  rescue NotFoundError => e
    ResponseBuilder.build(404, body: { error: e.message })
  rescue UnauthorizedError => e
    ResponseBuilder.build(401, body: { error: e.message })
  rescue StandardError => e
    ResponseBuilder.build(500, body: { error: e.message })
  end

  def process_route(env)
    env = parse_env(env)

    case env[:paths][0]
    when nil
      ResponseBuilder.serve_file('public/openapi.yaml', content_type: 'text/yaml', cache_control: 'no-cache')
    when 'authors', 'AUTHORS'
      ResponseBuilder.serve_file('public/AUTHORS', content_type: 'text/plain', cache_control: 'public, max-age=86400')
    when 'login'
      Routes::Auth.route(env)
    when 'products'
      Routes::Auth.validate_token!(env[:headers]['authorization'])

      Routes::Products.route(env)
    when 'jobs'
      Routes::Auth.validate_token!(env[:headers]['authorization'])
      Routes::Jobs.route(env)
    else
      raise NotFoundError, "Unknown route: #{env[:paths][0]}"
    end
  end

  def parse_env(env)
    {
      request_method: env['REQUEST_METHOD'].downcase.to_sym,
      paths: env['PATH_INFO'].split('/').reject(&:empty?),
      query_params: Rack::Utils.parse_nested_query(env['QUERY_STRING']),
      body: parse_request_body(env),
      headers: env.select { |k, _| k.start_with?('HTTP_') }.transform_keys { |k| k.sub('HTTP_', '').downcase }
    }
  end

  def parse_request_body(env)
    return {} unless env['rack.input'].respond_to?(:read)

    begin
      body = env['rack.input'].read
      JSON.parse(body)
    rescue JSON::ParserError
      {}
    end
  end
end
