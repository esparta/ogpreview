# frozen_string_literal: true

# Our main Controller
class PreviewController < ApplicationController
  def show
  end

  def create
    flash[:info] = 'Preview has been submitted'
    redirect_to root_path
  end
end
