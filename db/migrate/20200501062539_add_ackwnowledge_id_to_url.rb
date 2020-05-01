# frozen_string_literal: true

# We will use the ackwnowledge_id for the polling
# It can be combined with the user_id
class AddAckwnowledgeIdToUrl < ActiveRecord::Migration[6.1]
  def change
    add_column :urls, :acknowledge_id, :string, null: false
  end
end
