# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PreviewController, type: :controller do
  context 'GET /status' do
    it do
      url = Url.create(
        uri: 'http://example.com', acknowledge_id: SecureRandom.hex
      )

      get :status, params: {ack: url.acknowledge_id }
      expect(response).to have_http_status(:success)
    end
  end
end
