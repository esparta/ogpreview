# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Downloader::OpenGraph do
  subject do
    described_class.get(src)
  end
  let(:src) { 'http://example.com/get' }
  context 'Step 02 - OK' do
    let(:img) { 'https://example.com/img.jpg' }

    let(:head) { OpenStruct.new(location: src) }
    it do
      allow(HTTP).to receive(:head) { head }
      allow(::OpenGraph).to receive(:new) do
        OpenStruct.new(images: [img])
      end
      expect(subject).to be_success
    end
  end
  context 'Step 01 - failure' do
    let(:failure) { RuntimeError.new('Induced') }
    before(:each) do
      allow(::OpenGraph).to receive(:new).and_raise(failure)
    end
    it { is_expected.to be_failure }
    it { expect(subject.failure).to eq(failure) }
  end
end
