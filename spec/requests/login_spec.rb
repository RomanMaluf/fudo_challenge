# frozen_string_literal: true

RSpec.describe 'Login endpoint', type: :request do
  it 'returns token when correct credentials are provided' do
    post '/login', { username: 'admin', password: 'password' }.to_json, { 'CONTENT_TYPE' => 'application/json' }
    expect(last_response.status).to eq(200)
    parse_response = JSON.parse(last_response.body)
    expect(parse_response['token']).to be_present
  end

  it 'returns 404 when not valid method is used', openapi: false do
    get '/login'
    expect(last_response.status).to eq(404)
    expect(JSON.parse(last_response.body)).to eq({ 'error' => 'Resource not found' })
    expect(last_response.headers['Content-Type']).to eq('application/json')
  end
end
