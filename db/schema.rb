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

ActiveRecord::Schema[7.2].define(version: 2025_04_05_083749) do
  create_table "relationships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "following_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["following_id"], name: "index_relationships_on_following_id"
    t.index ["user_id", "following_id"], name: "index_relationships_on_user_id_and_following_id", unique: true
    t.index ["user_id"], name: "index_relationships_on_user_id"
  end

  create_table "sleep_records", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "start_at", null: false
    t.datetime "end_at"
    t.integer "duration_in_seconds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "start_at"], name: "index_sleep_records_on_user_id_and_start_at", unique: true
    t.index ["user_id"], name: "index_sleep_records_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_users_on_name"
  end

  add_foreign_key "relationships", "users"
  add_foreign_key "relationships", "users", column: "following_id"
  add_foreign_key "sleep_records", "users"
end
