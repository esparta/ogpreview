class AddStatusToUrls < ActiveRecord::Migration[6.1]
  def change
    add_column :urls, :status, :integer, null: false, default: 0
  end
end
