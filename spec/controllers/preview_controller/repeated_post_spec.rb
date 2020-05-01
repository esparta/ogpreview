# frozen_string_literal: true

require 'rails_helper'

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
        # Second post.
        # Should not create double entry
        post :create, params: { url: url }
        counting = Url.where(uri: url, user_id: cookies[:user_id]).count
        expect(counting).to eq(1)
      end
    end
  end
end
