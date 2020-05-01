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
      post '/'
      # Should fail since we are not sending the url param
      expect(response).to have_http_status(:bad_request)
    end
  end
end
