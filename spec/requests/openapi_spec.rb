# frozen_string_literal: true

RSpec.describe 'OpenAPI', type: :request, openapi: false do
  it 'returns the openapi.yml file' do
    get '/'

    expect(last_response.status).to eq(200)
    expect(last_response.content_type).to eq('text/yaml')
    expect(last_response.body).to include('openapi:')
  end

  it 'returns 404 for invalid method' do
    post '/'
    expect(last_response.status).to eq(404)
    expect(JSON.parse(last_response.body)).to eq({ 'error' => 'Unsupported method: post' })
    expect(last_response.headers['Content-Type']).to eq('application/json')
  end
end
