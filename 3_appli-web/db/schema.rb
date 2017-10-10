# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170210180731) do

  create_table "chaines", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "stream_id"
    t.index ["stream_id"], name: "index_chaines_on_stream_id"
  end

  create_table "images", force: :cascade do |t|
    t.string   "filename"
    t.integer  "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["video_id"], name: "index_images_on_video_id"
  end

  create_table "portraits", force: :cascade do |t|
    t.string   "filename"
    t.integer  "image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["image_id"], name: "index_portraits_on_image_id"
  end

  create_table "streams", force: :cascade do |t|
    t.string "type"
  end

  create_table "videos", force: :cascade do |t|
    t.string   "url"
    t.integer  "chaine_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chaine_id"], name: "index_videos_on_chaine_id"
  end

end
