# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Downloader::OpenGraph do
  subject do
    described_class.get(src)
  end
  let(:src) { 'http://example.com/get' }
  let(:img) do
    'https://example.com/img.jpg'
  end
  it do
    allow(Downloader).to receive(:get) do
      Dry::Monads::Success(
        '
          <html>HEAD</html>
          <body><img src="https://example.com/img.jpg"/>
        '
      )
    end
    allow(::OpenGraph).to receive(:new) do
      OpenStruct.new(images: [img])
    end
    expect(subject).to be_success
  end
end
