# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_02_032249) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "url_images", force: :cascade do |t|
    t.bigint "url_id", null: false
    t.string "uri"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["url_id"], name: "index_url_images_on_url_id"
  end

  create_table "urls", force: :cascade do |t|
    t.string "uri", null: false
    t.string "user_id"
    t.datetime "started_at"
    t.string "finished_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "acknowledge_id", null: false
    t.integer "status", default: 0, null: false
  end

  add_foreign_key "url_images", "urls"
end
