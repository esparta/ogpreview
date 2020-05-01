class CreateUrlImages < ActiveRecord::Migration[6.1]
  def change
    create_table :url_images do |t|
      t.references :url, null: false, foreign_key: true
      t.string :uri

      t.timestamps
    end
  end
end
