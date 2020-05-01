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
