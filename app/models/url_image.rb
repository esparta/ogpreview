# frozen_string_literal: true

# Every image of every OpenGraph
class UrlImage < ApplicationRecord
  belongs_to :url
end
