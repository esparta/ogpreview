require 'rails_helper'

RSpec.describe PreviewerJob, type: :job do
  describe 'perform_later' do
    let(:params) do
      { uri: 'https://example.com',
        user_id: SecureRandom.hex
      }
    end
    it do
      ActiveJob::Base.queue_adapter = :test
      expect do
        PreviewerJob.perform_later(params)
      end.to have_enqueued_job
    end
  end
end
