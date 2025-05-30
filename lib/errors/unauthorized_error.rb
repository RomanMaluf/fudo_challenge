# frozen_string_literal: true

class UnauthorizedError < StandardError
  def initialize(message = 'Unauthorized access')
    super(message)
  end
end
