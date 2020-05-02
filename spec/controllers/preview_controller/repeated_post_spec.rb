# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PreviewController, type: :controller do
  context 'POST' do
    context 'persisted post' do
      let(:url) { SecureRandom.hex }
      it do
        Url.create!(uri: url, acknowledge_id: SecureRandom.hex)
        # Second post.
        # Should not create double entry
        post :create, params: { url: url }
        counting = Url.where(uri: url).count
        expect(counting).to eq(1)
      end
    end
  end
end
