# frozen_string_literal: true

# When we can't locate the URL, it means we need to
# create and perform the previewing
class PreviewerJob < ApplicationJob
  queue_as :default

  def perform(uri:, user_id:)
    url = Url.create(
      uri: uri, user_id: user_id,
      acknowledge_id: job_id, started_at: DateTime.now
    )
    og = Downloader::OpenGraph.get(url.uri)
    return if og.failure?

    # Create their images
    og.value!.images.each do |image|
      url.url_images.create(uri: image)
    end
  end
end
