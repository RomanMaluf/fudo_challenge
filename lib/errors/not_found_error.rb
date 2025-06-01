# frozen_string_literal: true

# Custom error class for not found access
class NotFoundError < StandardError
  def initialize(message = 'Resource not found')
    super(message)
  end
end
