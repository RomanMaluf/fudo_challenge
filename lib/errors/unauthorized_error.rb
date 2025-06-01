# frozen_string_literal: true

# Custom error class for unauthorized access
class UnauthorizedError < StandardError
  def initialize(message = 'Unauthorized access')
    super(message)
  end
end
