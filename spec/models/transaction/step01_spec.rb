# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction do
  subject { described_class.call(uri, user_id, job_id) }

  let(:user_id) { SecureRandom.hex }
  let(:job_id) { SecureRandom.hex }
  let(:uri) { 'https://example.com' }
  context 'step 01' do
    context 'will fail with schema or model validations' do
      context 'no uri?' do
        let(:uri) { nil }
        it do
          expect do
            described_class.call(uri, user_id, job_id)
          end.to raise_error(ActiveRecord::NotNullViolation)
        end
      end

      context 'no acknoledge?' do
        let(:job_id) { nil }
        it do
          expect do
            described_class.call(uri, user_id, job_id)
          end.to raise_error(ActiveRecord::NotNullViolation)
        end
      end
    end
  end
end
