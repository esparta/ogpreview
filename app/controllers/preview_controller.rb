# frozen_string_literal: true

# Our main Controller
class PreviewController < ApplicationController
  def show
  end

  def create
    render json: { data: :oks }
  end
end
