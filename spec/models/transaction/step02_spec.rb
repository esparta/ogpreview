# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction do
  subject do
    described_class.call(uri, user_id, job_id)
  end
  let(:user_id) { SecureRandom.hex }
  let(:job_id) { SecureRandom.hex }
  let(:uri) { 'https://example.com' }

  context 'step 02' do
    context 'not able to parse the OpenGraph' do
      let(:failure) do
        RuntimeError.new('HTTP::Error')
      end
      before(:each) do
        allow(Downloader::OpenGraph).to receive(:get) do
          Dry::Monads::Result::Failure.new failure
        end
      end
      it { is_expected.to be_failure }
      it do
        url, _error = subject.failure
        expect(url).to be_error
      end
      it do
        _url, error = subject.failure
        expect(error).to match(reason: failure)
      end
    end
  end
end
