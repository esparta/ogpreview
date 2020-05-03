# frozen_string_literal: true

require 'dry/monads/do'

class Transaction
  class << self
    include Dry::Monads[:try, :result]
    include Dry::Monads::Do.for(:call)

    def call(uri, user_id, job_id)
      # The process
      # (url, user_id, job_id)
      #   |> create_url
      #   |> opengraph
      #   |> extract_images
      #   |> attach_images
      url = yield create_url(uri, user_id, job_id)
      parsed = yield opengraph(url)
      images = yield extract_images(parsed)
      attach_images(images)
    end

    private

    # Step 01 - Try to create the new URL
    def create_url(uri, user_id, job_id)
      Success(
        Url.new(
          uri: uri, user_id: user_id,
          acknowledge_id: job_id,
          started_at: DateTime.now
        ).tap(&:save)
      )
    end

    # Step 02 - Try to Parse the OpenGraph
    def opengraph(url)
      url.parsing!
      og = Downloader::OpenGraph.get(url.uri)
      if og.failure?
        url.error! # Update the progress
        # Finish the process
        Failure([url, { reason: og.failure }])
      else
        # Continue and return both, the url to pass on
        # and the OpenGraph object
        Success([url, og.value!])
      end
    end

    # Step 03 - Extract images
    def extract_images(params)
      url, opengraph = params
      images = opengraph.images
      if images.empty?
        # Nothing to process?
        url.ready!
        Failure([url, { reason: 'No images to process' }])
      else
        # We got images, pass along the Url
        # and the array of images
        Success([url, images])
      end
    end

    # Step 04 - Attach Images
    def attach_images(params)
      url, images = params
      url.downloading!
      images.each do |image_url|
        image = Downloader.get(image_url)
        if image.failure?
          url.error!
          return Failure(
            [url, { reason: image.failure }]
          )
        end

        url.url_images.create(uri: image_url).tap do |new_image|
          file = image.value!
          new_image.image.attach(io: file, filename: File.basename(image_url))
        end
      end
      # We are done, return the sucessful Url
      url.ready!
      Success(url)
    end
  end
end
