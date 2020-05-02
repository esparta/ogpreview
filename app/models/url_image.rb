# frozen_string_literal: true

# Every image of every OpenGraph
class UrlImage < ApplicationRecord
  belongs_to :url
  has_one_attached :image
end
