# frozen_string_literal: true

class NotFoundError < StandardError
  def initialize(message = 'Resource not found')
    super(message)
  end
end

# Example usage:
# raise NotFoundError.new("User with ID 123 not found")
# raise NotFoundError.new if you want to use the default message
# This custom error can be rescued in your application to handle 404 errors gracefully.
# For example, in a Rack application, you might do something like this:

# rescue_from NotFoundError do |e|
#   [404, { 'content-type' => 'application/json' }, [{ error: e.message }.to_json]]
# end
