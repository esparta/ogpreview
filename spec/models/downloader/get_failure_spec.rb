# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Downloader do
  subject do
    Downloader.get(src)
  end
  context '#get' do
    context 'failure' do
      let(:src) { 'notexistent' }
      it do
        allow(
          Down::Http
        ).to receive(:open).and_raise(
          Down::ConnectionError
        )
        is_expected.to be_failure
      end
    end
  end
end
