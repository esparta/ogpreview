# frozen_string_literal: true

# When we can't locate the URL, it means we need to
# create and perform the previewing
class PreviewerJob < ApplicationJob
  queue_as :default

  def perform(uri:, user_id:)
    transaction = Transaction.call(uri, user_id, job_id)
    Rails.logger.error(transaction.failure) if transaction.failure?
  end
end
