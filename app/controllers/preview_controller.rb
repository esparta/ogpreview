# frozen_string_literal: true

# Our main Controller
class PreviewController < ApplicationController
  before_action :assign_user_id
  before_action :url_contract

  def show
  end

  def create
    if @url_contract.success?
      url = Url.find_or_initialize_by(search_hash) do |new|
        new.update(persisted_hash)
      end

      render json: { ack: url.acknowledge_id }
    else
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

  def persisted_hash
    { acknowledge_id: SecureRandom.hex,
      started_at: DateTime.now }
  end

  def url_contract
    @url_contract ||= UrlContracts::Input.new.call(url_params)
  end
end
