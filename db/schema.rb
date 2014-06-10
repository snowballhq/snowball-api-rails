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

ActiveRecord::Schema.define(version: 20140503013513) do

  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'
  enable_extension 'uuid-ossp'

  create_table 'clips', id: :uuid, default: 'uuid_generate_v4()', force: true do |t|
    t.uuid 'reel_id',         null: false
    t.uuid 'user_id',         null: false
    t.string 'video_file_name', null: false
    t.integer 'zencoder_job_id'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'identities', id: :uuid, default: 'uuid_generate_v4()', force: true do |t|
    t.uuid 'user_id',    null: false
    t.string 'uid',        null: false
    t.string 'provider',   null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'likes', id: :uuid, default: 'uuid_generate_v4()', force: true do |t|
    t.uuid 'user_id',       null: false
    t.uuid 'likeable_id',   null: false
    t.string 'likeable_type', null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'notifications', id: :uuid, default: 'uuid_generate_v4()', force: true do |t|
    t.uuid 'user_id',         null: false
    t.uuid 'notifiable_id',   null: false
    t.string 'notifiable_type', null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'reels', id: :uuid, default: 'uuid_generate_v4()', force: true do |t|
    t.string 'name'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'users', id: :uuid, default: 'uuid_generate_v4()', force: true do |t|
    t.string 'name',                   null: false
    t.string 'username',               null: false
    t.string 'bio'
    t.string 'avatar_file_name'
    t.string 'auth_token',             null: false
    t.string 'email',                  null: false
    t.string 'encrypted_password',     null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'users', ['auth_token'], name: 'index_users_on_auth_token', unique: true, using: :btree
  add_index 'users', ['email'], name: 'index_users_on_email', unique: true, using: :btree
  add_index 'users', ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true, using: :btree
  add_index 'users', ['username'], name: 'index_users_on_username', unique: true, using: :btree

end
