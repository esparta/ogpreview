# frozen_string_literal: true

# Our main Controller
class PreviewController < ApplicationController
  before_action :assign_user_id
  before_action :url_contract, only: [:create]

  def show
  end

  def status
    ack = params[:ack]
    url = Url.find_by!(acknowledge_id: ack)

    render(json: { images: url.url_images.map(&:uri) })
  end

  def create
    if @url_contract.success?
      url = Url.find_or_initialize_by(search_hash)

      ack = url.acknowledge_id || SecureRandom.hex

      if url.new_record?
        # If new record. Save it
        url.update(acknowledge_id: ack, started_at: DateTime.now)
        og = Downloader::OpenGraph.get(url.uri)
        if og.success?
          # and also their images
          og.value!.images.each do |image|
            url.url_images.create(uri: image)
          end
        end
      end
      render(json: { ack: ack })
    else
      # Bad URL
      render json: { errors: @url_contract.errors.to_h }, status: 400
    end
  end

  private

  def assign_user_id
    return if cookies[:user_id]

    cookies[:user_id] = SecureRandom.hex
  end

  def url_params
    params.permit(:url, :authenticity_token, :commit).to_h.symbolize_keys
  end

  def search_hash
    { user_id: cookies[:user_id],
      uri: @url_contract.to_h[:url] }
  end

  def url_contract
    @url_contract ||= UrlContracts::Input.new.call(url_params)
  end
end
