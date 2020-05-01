# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Downloader do
  subject do
    described_class.new.get(src)
  end
  context 'open' do
    context 'not existent' do
      let(:src) { 'http://notexistent' }
      it do
        allow(
          Down::Http
        ).to receive(:open).and_raise(
          Down::ConnectionError
        )
        expect(subject).to be_failure
      end
    end
  end
end
