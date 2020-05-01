# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlImage, type: :model do
  it 'require url reference' do
    expect do
      UrlImage.create!(
        uri: 'https://example.com/img.jpg'
      )
    end.to raise_error(ActiveRecord::RecordInvalid)
  end
end
