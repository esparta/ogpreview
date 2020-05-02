# frozen_string_literal: true

# Persistency of the Preview requests
class Url < ApplicationRecord
  # schema:
  #   uri: string -> not null
  #   acknowledge_id: string -> not null
  #   status: integer -> not null
  #   user_id: string -> nullable
  #   started_at: datetime -> nullable
  #   finished_at: datetime -> nullable
  has_many :url_images
  enum status: {
    enqueued: 0,
    parsing: 1,
    downloading: 2,
    ready: 3,
    error: 4
  }
end
