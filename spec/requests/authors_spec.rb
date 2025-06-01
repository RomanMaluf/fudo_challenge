# frozen_string_literal: true

RSpec.describe 'Authors endpoint', type: :request do
  it 'returns Authors name' do
    get '/AUTHORS'
    puts last_response.body
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq("Roman Elias Maluf\n")
    expect(last_response.headers['Content-Type']).to eq('text/plain')
    expect(last_response.headers['Cache-Control']).to eq('public, max-age=86400')
    expect(last_response.headers['Content-Length']).to eq('18')
  end

  it 'returns 404 for non-existing path', openapi: false do
    get '/non-existing-path'
    expect(last_response.status).to eq(404)
    expect(JSON.parse(last_response.body)).to eq({ 'error' => 'Unknown route: non-existing-path' })
    expect(last_response.headers['Content-Type']).to eq('application/json')
  end

  it 'returns 404 for invalid method', openapi: false do
    post '/AUTHORS'
    expect(last_response.status).to eq(404)
    expect(JSON.parse(last_response.body)).to eq({ 'error' => 'Unsupported method: post' })
    expect(last_response.headers['Content-Type']).to eq('application/json')
  end
end
