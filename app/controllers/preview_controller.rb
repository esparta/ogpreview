# frozen_string_literal: true

# Our main Controller
class PreviewController < ApplicationController
  before_action :assign_user_id

  def show
  end

  def create
    url_contract = UrlContracts::Input.new.call(url_params)
    if url_contract.success?
      ack = SecureRandom.hex
      url = { user_id: cookies[:user_id],
              uri: url_contract.to_h[:url],
              acknowledge_id: ack }
      Url.create!(url)

      render json: { ack: ack }
    else
      render json: { errors: url_contract.errors.to_h }, status: 400
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
end
