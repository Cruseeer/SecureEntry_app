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

ActiveRecord::Schema[7.1].define(version: 2024_01_18_204525) do
  create_table "accesses", force: :cascade do |t|
    t.integer "user_id"
    t.integer "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_accesses_on_room_id"
    t.index ["user_id", "room_id"], name: "index_accesses_on_user_id_and_room_id", unique: true
    t.index ["user_id"], name: "index_accesses_on_user_id"
  end

  create_table "logs", force: :cascade do |t|
    t.datetime "time"
    t.boolean "accessed"
    t.integer "user_id", null: false
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_logs_on_room_id"
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "lost_cards", force: :cascade do |t|
    t.datetime "time"
    t.string "description"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_lost_cards_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "login"
    t.string "password_digest"
    t.boolean "isadmin"
  end

  add_foreign_key "logs", "rooms"
  add_foreign_key "logs", "users"
  add_foreign_key "lost_cards", "users"
end
