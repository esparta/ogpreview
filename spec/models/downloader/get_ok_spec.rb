# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Downloader do
  subject do
    described_class.get(src)
  end
  context '#get' do
    context ':success' do
      let(:src) { 'http://example.coms' }
      it do
        allow(
          Down::Http
        ).to receive(:open).and_return(
          Down::ChunkedIO.new(chunks: ['data'])
        )
        expect(subject).to be_success
        expect(subject.value!).to be_truthy
      end
    end
  end
end
