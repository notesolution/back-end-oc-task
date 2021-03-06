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

ActiveRecord::Schema.define(version: 20180227050318) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chapters", force: :cascade do |t|
    t.integer "number"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "doors", force: :cascade do |t|
    t.string "img"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "final", default: false
  end

  create_table "edges", force: :cascade do |t|
    t.integer "room_parent_id"
    t.integer "room_child_id"
    t.bigint "chapter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_edges_on_chapter_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "number"
    t.bigint "chapter_id"
    t.bigint "door_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "final", default: false
    t.index ["chapter_id"], name: "index_rooms_on_chapter_id"
    t.index ["door_id"], name: "index_rooms_on_door_id"
  end

  create_table "user_actions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "chapter_id"
    t.bigint "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_user_actions_on_chapter_id"
    t.index ["room_id"], name: "index_user_actions_on_room_id"
    t.index ["user_id"], name: "index_user_actions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "edges", "chapters"
  add_foreign_key "rooms", "chapters"
  add_foreign_key "rooms", "doors"
end
