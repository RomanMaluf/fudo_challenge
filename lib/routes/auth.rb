# frozen_string_literal: true

module Routes
  class Auth
    def self.route(env)
      raise NotFoundError unless env[:request_method] == :post

      username = env[:body]['username'] || env[:query_params]['username']
      password = env[:body]['password'] || env[:query_params]['password']
      action = env[:paths][0]

      case action
      when 'login'
        raise UnauthorizedError, 'Invalid username or password' unless username == 'admin' && password == 'password'

        ResponseBuilder.build(200, body: { message: 'Login successful', token: generate_token }.to_json)
      else
        raise :NotFoundError, "Unknown action: #{action}"
      end
    end

    def self.generate_token
      timestamp = Time.now.to_i.to_s
      raw_token = "#{timestamp}:#{FudoChallenge::API_TOKEN}"
      hash = Digest::MD5.hexdigest(raw_token)
      "#{hash}:#{timestamp}"
    end

    def self.validate_token!(token)
      raise UnauthorizedError, 'Token is required' if token.nil? || token.empty?

      hash, timestamp = token.split(':')
      expected_hash = Digest::MD5.hexdigest("#{timestamp}:#{FudoChallenge::API_TOKEN}")
      raise UnauthorizedError, 'Invalid token' unless hash == expected_hash

      true
    end
  end
end
