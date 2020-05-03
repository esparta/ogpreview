# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PreviewController, type: :controller do
  context 'POST' do
    context 'persisted post' do
      let(:user_id) { '65ab76582273dbb11372ff61acd642c7A' }
      let(:url) { 'http://example.com' }
      it do
        post :create, params: { opengraph: { url: url } }
        expect(response).to have_http_status(:success)
      end
    end
  end
end
