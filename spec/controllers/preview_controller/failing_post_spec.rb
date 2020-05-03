# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PreviewController, type: :controller do
  context 'POST' do
    context 'failing post' do
      let(:url) { 'nop' }
      it do
        post :create, params: { opengraph: { url: url } }
        expect(response).to have_http_status(:bad_request)
        expect(
          JSON.parse(response.body)
        ).to match('errors' => { 'url' => ['size cannot be less than 4'] })
      end
    end
  end
end
