# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Root', type: :request do
  describe 'GET /' do
    it 'return http success' do
      get '/'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /' do
    it 'return http success' do
      post '/', params: { opengraph: { url_text: 'uht' } }
      # Should fail since we are sending wrong param
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'GET /status' do
    it 'return http success' do

      url = Url.create(uri: 'http://example.com', acknowledge_id: SecureRandom.hex)
      get '/status', params: {ack: url.acknowledge_id }
      expect(response).to have_http_status(:success)
    end
  end
end
