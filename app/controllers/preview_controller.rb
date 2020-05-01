# frozen_string_literal: true

# Our main Controller
class PreviewController < ApplicationController
  before_action :assign_user_id

  def show
  end

  def create
    render json: { ack: SecureRandom.hex }
  end

  private

  def assign_user_id
    return if cookies[:user_id]

    cookies[:user_id] = SecureRandom.hex
  end
end
