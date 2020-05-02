# frozen_string_literal: true

# Our main Controller
class PreviewController < ApplicationController
  before_action :assign_user_id
  before_action :url_contract, only: [:create]

  def show
  end

  def status
    url = Url.find_by(acknowledge_id: params[:ack])
    render(json: { status: :enqueued }) and return unless url

    if url.ready?
      render(json: { status: :ready, images: url.url_images.map(&:uri) })
    else
      render json: { status: url.status }
    end
  end

  def create
    if @url_contract.success?
      url = Url.find_by(uri: @url_contract[:url])
      ack = url&.acknowledge_id || PreviewerJob.perform_later(search_hash).job_id

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
