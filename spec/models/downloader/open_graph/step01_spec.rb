# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Downloader::OpenGraph do
  subject do
    described_class.get(src)
  end
  let(:src) { 'http://example.com/get' }
  context 'Step 01 - failure' do
    # We don't test positive because will be tested on
    # Step 02
    let(:failure) { RuntimeError.new('Induced') }
    before(:each) do
      allow(HTTP).to receive(:head).and_raise(failure)
    end
    it { is_expected.to be_failure }
    it { expect(subject.failure).to eq(failure) }
  end
end
