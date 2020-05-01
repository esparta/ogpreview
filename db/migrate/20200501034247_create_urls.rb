# frozen_string_literal: true

# Initial migration for previews
class CreateUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :urls do |t|
      t.string :uri, null: false
      t.string :user_id, null: true
      t.string :image_uri, null: true
      t.datetime :started_at, null: true
      t.string :finished_at, null: true

      t.timestamps
    end
  end
end
