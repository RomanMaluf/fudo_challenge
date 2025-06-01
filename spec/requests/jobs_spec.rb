# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Jobs endpoint', type: :request do
  context 'when authenticated' do
    before do
      post '/login', { username: 'admin', password: 'password' }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      @token = JSON.parse(last_response.body)['token']
      @headers = { 'HTTP_AUTHORIZATION' => @token.to_s, 'CONTENT_TYPE' => 'application/json' }
    end

    it 'returns a list of all jobs' do
      sutb_jobs_statutes

      get '/jobs/all', {}, @headers

      expected_response = {
        'jobs' => {
          'job1' => 'queued',
          'job2' => 'failed',
          'job3' => 'completed'
        }
      }

      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq(expected_response)
    end

    it 'returns a specific job for show action' do
      post '/products', { id: SecureRandom.hex(4), name: 'Test Job' }.to_json, @headers
      response = JSON.parse(last_response.body)

      get "/jobs/#{response['job_id']}", {}, @headers
      expect(last_response.status).to eq(200)
      parsed_response = JSON.parse(last_response.body)
      expect(parsed_response['job_id']).to eq(response['job_id'])
      expect(parsed_response['status']).to eq('queued')
    end

    it 'returns 404 for non-existing job', openapi: false do
      get '/jobs/non-existing-job', {}, @headers
      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)).to eq({ 'error' => 'Job with ID non-existing-job not found' })
    end

    it 'returns 400 when job ID is missing', openapi: false do
      get '/jobs/', {}, @headers
      expect(last_response.status).to eq(400)
      expect(JSON.parse(last_response.body)).to eq({ 'error' => 'Job ID is required' })
    end

    it 'returns 404 for unsupported method', openapi: false do
      put '/jobs', {}, @headers
      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)).to eq({ 'error' => 'Unsupported method for /jobs route: put' })
    end
  end

  context 'when not authenticated' do
    it 'returns unauthorized when missing credentials', openapi: false do
      get '/jobs'
      expect(last_response.status).to eq(401)
    end
  end

  private

  def sutb_jobs_statutes
    allow(Jobs::InsertProduct).to receive(:statuses).and_return({
                                                                  'job1' => 'queued',
                                                                  'job2' => 'failed',
                                                                  'job3' => 'completed'
                                                                })
  end
end
# rubocop:enable Metrics/BlockLength
