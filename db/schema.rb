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

ActiveRecord::Schema[7.0].define(version: 2023_02_20_041321) do
  create_table "Films", force: :cascade do |t|
    t.string "title", limit: 255
    t.integer "episode_id"
    t.string "opening_crawl", limit: 255
    t.string "director", limit: 255
    t.string "producer", limit: 255
    t.datetime "release_date", precision: nil
  end

  create_table "Films_People", force: :cascade do |t|
    t.integer "film_id"
    t.integer "person_id"
  end

  create_table "Films_Planets", force: :cascade do |t|
    t.integer "film_id"
    t.integer "planet_id"
  end

  create_table "People", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "birth_year", limit: 255
    t.string "eye_color", limit: 255
    t.string "gender", limit: 255
    t.string "hair_color", limit: 255
    t.string "height", limit: 255
    t.string "mass", limit: 255
    t.string "skin_color", limit: 255
    t.integer "planet_id"
  end

  create_table "Planets", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "diameter", limit: 255
    t.string "rotation_period", limit: 255
    t.string "orbital_period", limit: 255
    t.string "gravity", limit: 255
    t.string "population", limit: 255
    t.string "climate", limit: 255
    t.string "terrain", limit: 255
    t.string "surface_water", limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "password"
  end

  add_foreign_key "Films_People", "Films", column: "film_id"
  add_foreign_key "Films_People", "People", column: "person_id"
  add_foreign_key "Films_Planets", "Films", column: "film_id"
  add_foreign_key "Films_Planets", "Planets", column: "planet_id"
  add_foreign_key "People", "Planets", column: "planet_id"
end
