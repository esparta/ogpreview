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
end

RSpec.describe PreviewController, type: :controller do
  context 'POST' do
    context 'failing post' do
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
end

RSpec.describe PreviewController, type: :controller do
  context 'POST' do
    context 'persisted post' do
      let(:user_id) { '65ab76582273dbb11372ff61acd642c7A' }
      let(:url) { 'example.com' }
      it do
        allow(SecureRandom).to receive(:hex) { user_id }
        post :create, params: { url: url }
        new_url = Url.find_by(uri: url, user_id: cookies[:user_id])
        expect(new_url).to be_truthy
      end
    end
  end
end
