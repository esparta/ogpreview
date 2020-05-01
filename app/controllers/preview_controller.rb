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

      render(json: hash_to_response(url)) and return unless url.new_record?

      # If new record. Save it
      url.update(persisted_hash)

      og = Downloader::OpenGraph.get(url.uri)
      render(json: { ack: url.acknowledge_id }, status: 400) and return unless og.success?

      # and also their images
      og.value!.images.each do |image|
        url.url_images.create(uri: image)
      end

      render(json: hash_to_response(url))
    else
      # Bad URL
      render json: { errors: @url_contract.errors.to_h }, status: 400
    end
  end

  private

  def hash_to_response(url)
    { ack: url.acknowledge_id }
  end

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

  def persisted_hash
    { acknowledge_id: SecureRandom.hex,
      started_at: DateTime.now }
  end

  def url_contract
    @url_contract ||= UrlContracts::Input.new.call(url_params)
  end
end
