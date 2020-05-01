# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PreviewController, type: :controller do
  context 'GET / cookies' do
    let(:user_id) { '65ab76582273dbb11372ff61acd642c7A' }
    it do
      allow(SecureRandom).to receive(:hex) { user_id }
      get :show
      expect(cookies[:user_id]).to eq(user_id)
    end
  end

  context 'POST' do
    let(:url) { 'nop' }
    it do
      post :create, params: { url: url }
      expect(response).to have_http_status(:bad_request)
      expect(
        JSON.parse(response.body)
      ).to match('errors' => { 'url' => ['size cannot be less than 4'] })
    end
  end
end
