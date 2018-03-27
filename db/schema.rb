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

ActiveRecord::Schema.define(version: 20180327013809) do

  create_table "reviews", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "toilet_id", null: false
    t.integer "user_id", null: false
    t.float "valuation", limit: 24
    t.string "message"
    t.datetime "updated_at", null: false
    t.datetime "created_at", null: false
  end

  create_table "toilets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "google_id"
    t.float "lat", limit: 24, null: false
    t.float "lng", limit: 24, null: false
    t.string "geolocation"
    t.string "image_path"
    t.string "description"
    t.float "valuation", limit: 24
    t.datetime "updated_at", null: false
    t.datetime "created_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "icon_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users_toilets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id", null: false
    t.integer "toilet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
