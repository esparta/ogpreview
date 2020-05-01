# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  context 'has many' do
    it do
      url = Url.create(
        uri: 'https://example.com',
        acknowledge_id: SecureRandom.hex
      )
      expect(url.url_images).to be_empty
    end
  end

  context 'URI' do
    it 'requires URI at database level' do
      expect do
        Url.create!(user_id: SecureRandom.hex)
      end.to raise_exception(ActiveRecord::NotNullViolation)
    end
  end

  context 'Acknowled_Id' do
    it 'is not null' do
      expect do
        Url.create!(user_id: SecureRandom.hex, uri: 'example.com')
      end.to raise_exception(ActiveRecord::NotNullViolation)
    end
  end
end
