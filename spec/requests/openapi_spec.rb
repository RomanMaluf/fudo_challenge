# frozen_string_literal: true

RSpec.describe 'OpenAPI', type: :request, openapi: false do
  describe 'GET /' do
    it 'returns the openapi.yml file' do
      get '/'

      expect(last_response.status).to eq(200)
      expect(last_response.content_type).to eq('text/yaml')
      expect(last_response.body).to include('openapi:')
    end
  end
end
