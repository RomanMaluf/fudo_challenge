# frozen_string_literal: true

require 'spec_helper'
require 'rack/mock'
require_relative '../../lib/middlewares/gzip'

# rubocop:disable Metrics/BlockLength
RSpec.describe Middlewares::Gzip do
  let(:inner_app) do
    ->(_env) { [200, { 'Content-Type' => 'text/plain' }, ['Hello world']] }
  end

  let(:middleware) { described_class.new(inner_app) }
  let(:request) { Rack::MockRequest.new(middleware) }

  context 'when client does NOT accept gzip' do
    it 'returns original response uncompressed' do
      response = request.get('/')
      expect(response.status).to eq(200)
      expect(response.headers['content-encoding']).to be_nil
      expect(response.body).to eq('Hello world')
    end
  end

  context 'when client accepts gzip' do
    it 'returns gzipped response' do
      response = request.get('/', 'HTTP_ACCEPT_ENCODING' => 'gzip')
      expect(response.status).to eq(200)
      expect(response.headers['content-encoding']).to eq('gzip')
      expect(response.headers['content-length']).to be_present

      # Gunzip the response body for verification
      body_io = StringIO.new(response.body)
      gz = Zlib::GzipReader.new(body_io)
      decompressed_body = gz.read
      gz.close

      expect(decompressed_body).to eq('Hello world')
    end
  end

  context 'when content is already gzipped' do
    let(:gzipped_body) do
      io = StringIO.new
      Zlib::GzipWriter.wrap(io) { |gz| gz.write('Already compressed') }
      io.string
    end

    let(:inner_app) do
      ->(_env) { [200, { 'content-encoding' => 'gzip' }, [gzipped_body]] }
    end

    it 'does not double-compress the response' do
      response = request.get('/', { 'HTTP_ACCEPT_ENCODING' => ['gzip'] })
      expect(response.status).to eq(200)
      expect(response.headers['content-encoding']).to eq('gzip')
      expect(response.body).to eq(gzipped_body)
    end
  end
end
# rubocop:enable Metrics/BlockLength
