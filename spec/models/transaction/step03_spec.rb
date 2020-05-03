# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction do
  subject do
    described_class.call(uri, user_id, job_id)
  end
  let(:user_id) { SecureRandom.hex }
  let(:job_id) { SecureRandom.hex }
  let(:uri) { 'https://example.com' }

  context 'step 03' do
    context 'has no images' do
      let(:opengraph) { double(OpenGraph, images: []) }
      before(:each) do
        allow(Downloader::OpenGraph).to receive(:get) do
          Dry::Monads::Success(opengraph)
        end
      end
      it { is_expected.to be_failure }

      it do
        _url, error = subject.failure
        expect(error).to match(reason: /No images/)
      end
      it do
        url, _error = subject.failure
        expect(url).to be_ready
      end
    end
  end
end
