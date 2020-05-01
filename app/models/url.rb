# frozen_string_literal: true

# Persistency of the Preview requests
class Url < ApplicationRecord
  # schema:
  #   uri: string -> not null
  #   image_uri: string -> nullable
  #   user_id: string -> nullable
  #   started_at: datetime -> nullable
  #   finished_at: datetime -> nullable
  has_many :url_images
end
