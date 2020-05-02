# frozen_string_literal: true

# When we can't locate the URL, it means we need to
# create and perform the previewing
class PreviewerJob < ApplicationJob
  queue_as :default

  def perform(uri:, user_id:)
    Url.transaction do
      url = Url.create(
        uri: uri, user_id: user_id,
        acknowledge_id: job_id, started_at: DateTime.now
      )
      og = Downloader::OpenGraph.get(url.uri)
      if og.failure?
        url.error!
      else
        url.parsing!

        # Create their images
        url.downloading!
        results = og.value!.images.map do |image_url|
          image = Downloader.get(image_url)
          if image.success?
            url.url_images.create(uri: image_url).tap do |new_image|
              image = Downloader.get(image_url)
              if image.success?
                new_image.image.attach(
                  io: image.value!,
                  filename: 'image.jpg'
                )
              end
            end
          else
            false
          end
        end
        results.all? ? url.ready! : url.error!
      end
    end
  end
end
