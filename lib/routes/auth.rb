# frozen_string_literal: true

module Routes
  # Auth Route Handler
  class Auth
    class << self
      def route(env)
        raise NotFoundError unless env[:request_method] == :post

        action = env[:paths][0]

        case action
        when 'login'
          handle_login(*extract_credentials(env))
        end
      end

      def extract_credentials(env)
        username = env[:body]['username'] || env[:query_params]['username']
        password = env[:body]['password'] || env[:query_params]['password']

        [username, password]
      end

      def handle_login(username, password)
        raise UnauthorizedError, 'Invalid username or password' unless username == 'admin' && password == 'password'

        token = generate_token
        ResponseBuilder.build(200, body: { message: 'Login successful', token: token })
      end

      def generate_token
        timestamp = Time.now.to_i.to_s
        raw_token = "#{timestamp}:#{FudoChallenge::API_TOKEN}"
        hash = Digest::MD5.hexdigest(raw_token)
        "#{hash}:#{timestamp}"
      end

      def validate_token!(token)
        raise UnauthorizedError, 'Token is required' if token.nil? || token.empty?

        hash, timestamp = token.split(':')
        expected_hash = Digest::MD5.hexdigest("#{timestamp}:#{FudoChallenge::API_TOKEN}")
        raise UnauthorizedError, 'Invalid token' unless hash == expected_hash

        true
      end
    end
  end
end
