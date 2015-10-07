# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151007014635) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "clips", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id",                null: false
    t.string   "video_file_name",        null: false
    t.string   "video_content_type",     null: false
    t.string   "thumbnail_file_name",    null: false
    t.string   "thumbnail_content_type", null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "video_file_size"
    t.string   "thumbnail_file_size"
    t.datetime "video_updated_at"
    t.datetime "thumbnail_updated_at"
  end

  create_table "flags", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "clip_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "follows", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "following_id", null: false
    t.uuid     "follower_id",  null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "likes", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id",    null: false
    t.uuid     "clip_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "username",               null: false
    t.string   "password_digest",        null: false
    t.string   "name"
    t.string   "email",                  null: false
    t.string   "phone_number"
    t.string   "auth_token",             null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.string   "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
