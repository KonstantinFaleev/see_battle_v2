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

ActiveRecord::Schema.define(version: 20180327201446) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.integer "player_id"
    t.text "grid"
    t.text "available_ships"
    t.boolean "direction", default: false
    t.boolean "saved", default: false
    t.string "title", default: "No title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string "content"
    t.integer "player_id"
    t.integer "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved", default: false
    t.index ["player_id", "game_id", "created_at"], name: "index_comments_on_player_id_and_game_id_and_created_at"
  end

  create_table "games", force: :cascade do |t|
    t.integer "player_a_id"
    t.integer "player_b_id"
    t.integer "winner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_a_ships", default: 20
    t.integer "player_b_ships", default: 20
    t.text "player_a_board"
    t.text "player_b_board"
    t.string "play_status"
    t.integer "looser_id"
    t.text "ai_moves_pull"
    t.text "ai_neglected_moves"
    t.text "game_log", default: "Game has started."
    t.string "title"
  end

  create_table "newsposts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.integer "rating", default: 100
    t.string "remember_token"
    t.boolean "admin", default: false
    t.integer "ships_lost", default: 0
    t.integer "ships_destroyed", default: 0
    t.datetime "last_response_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_players_on_deleted_at"
    t.index ["last_response_at"], name: "index_players_on_last_response_at"
    t.index ["name"], name: "index_players_on_name", unique: true
    t.index ["remember_token"], name: "index_players_on_remember_token"
  end

  create_table "ships", force: :cascade do |t|
    t.integer "decks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
