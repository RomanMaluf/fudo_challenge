# frozen_string_literal: true

RSpec.describe 'Products endpoint', type: :request do
  context 'when authenticated' do
    before do
      post '/login', { username: 'admin', password: 'password' }.to_json, { 'CONTENT_TYPE' => 'application/json' }
      @token = JSON.parse(last_response.body)['token']
      @headers = { 'HTTP_AUTHORIZATION' => @token.to_s, 'CONTENT_TYPE' => 'application/json' }
    end

    context 'GET /products' do
      it 'returns a list of products' do
        get '/products', {}, @headers
        expect(last_response.status).to eq(200)
        parse_response = JSON.parse(last_response.body)
        expect(parse_response['products']).to be_an_instance_of(Array)
        expect(parse_response['products'].first).to have_key('id')
        expect(parse_response['products'].first).to have_key('name')
      end

      it 'returns 500 when an internal error occurs' do
        allow(Product).to receive(:all).and_raise(StandardError.new('Internal Server Error'))
        get '/products', {}, @headers
        expect(last_response.status).to eq(500)
        parse_response = JSON.parse(last_response.body)
        expect(parse_response['error']).to eq('Internal Server Error')
      end
    end

    context 'POST /products' do
      it 'enqueues a job to insert a product' do
        post '/products', { id: SecureRandom.hex(4), name: 'New Product', price: 19.99 }.to_json, @headers
        expect(last_response.status).to eq(201)
        parse_response = JSON.parse(last_response.body)
        expect(parse_response['message']).to eq('Product enqueued for insertion')
      end

      it 'after 5 seconds new product should be available' do
        post '/products', { id: SecureRandom.hex(4), name: 'Delayed Product', price: 29.99 }.to_json, @headers
        expect(last_response.status).to eq(201)
        sleep(0.3) # Wait for the job to complete
        get '/products', {}, @headers
        parse_response = JSON.parse(last_response.body)
        product = parse_response['products'].find { |p| p['name'] == 'Delayed Product' }
        expect(product).not_to be_nil
        expect(product['price']).to eq(29.99)
      end

      context 'when product data is invalid' do
        it 'returns 201 when required fields are missing but job should failed' do
          post '/products', { name: 'Invalid Product' }.to_json, @headers
          parse_response = JSON.parse(last_response.body)
          expect(last_response.status).to eq(201)

          sleep(0.3) # Wait for the job to complete

          get "jobs/#{parse_response['job_id']}", {}, @headers
          parse_response = JSON.parse(last_response.body)
          expect(parse_response['status']).to eq('failed')
        end

        it 'returns 201 when id is not unique but job should failed' do
          post '/products', { id: 1, name: 'Invalid Product' }.to_json, @headers
          parse_response = JSON.parse(last_response.body)
          expect(last_response.status).to eq(201)
          sleep(0.3) # Wait for the job to complete

          get "jobs/#{parse_response['job_id']}", {}, @headers
          parse_response = JSON.parse(last_response.body)
          expect(parse_response['status']).to eq('failed')
        end
      end
    end

    context 'PUT /products/:id' do
      it 'returns 404 due method not implmented yet' do
        put '/products/1', { name: 'Updated Product' }.to_json, @headers
        expect(last_response.status).to eq(404)
        parse_response = JSON.parse(last_response.body)
        expect(parse_response['error']).to eq('Unsupported method: put')
      end
    end
  end

  context 'when not authenticated' do
    it 'returns unauthorized when missing credentials' do
      get '/products'
      expect(last_response.status).to eq(401)
    end
  end
end
