# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction do
  subject do
    described_class.call(uri, user_id, job_id)
  end
  let(:user_id) { SecureRandom.hex }
  let(:job_id) { SecureRandom.hex }
  let(:uri) { 'https://example.com' }

  let(:image) { 'http://example.com/image.jpg' }
  let(:opengraph) { double(OpenGraph, images: [image]) }
  let(:file) do
    File.open(
      Rails.root.join('spec', 'fixtures', 'files', 'image_test.gif')
    )
  end
  before(:each) do
    allow(Downloader::OpenGraph).to receive(:get) do
      Dry::Monads::Success(opengraph)
    end
    allow(Downloader).to receive(:get) do
      Dry::Monads::Success(file)
    end
  end

  context 'step 04' do
    context 'URL is ready' do
      it do
        url = subject.value!
        expect(url.as_json).to include(
          'uri' => uri, 'acknowledge_id' => job_id,
          'user_id' => user_id, 'status' => 'ready'
        )
      end
    end

    context 'not able to download image' do
      let(:failure) do
        # Simulated exception
        Down::NotFound.new("418 I'm teapot")
      end
      before(:each) do
        allow(Downloader).to receive(:get) do
          Dry::Monads::Result::Failure.new failure
        end
      end
      it { is_expected.to be_failure }

      it do
        _url, error = subject.failure
        expect(error).to match(reason: failure)
      end

      it do
        url, _error = subject.failure
        expect(url).to be_error
      end
    end
  end
end
