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

ActiveRecord::Schema.define(version: 20141202184902) do

  create_table "application_details", force: true do |t|
    t.string   "purpose"
    t.text     "description"
    t.text     "the_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patron_status_permissions", force: true do |t|
    t.string   "patron_status_code"
    t.string   "sublibrary_code"
    t.integer  "permission_value_id"
    t.boolean  "from_aleph",          default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",             default: true
  end

  create_table "patron_statuses", force: true do |t|
    t.string   "code"
    t.string   "original_text"
    t.string   "web_text"
    t.text     "description"
    t.boolean  "from_aleph",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",       default: true
    t.string   "id_type"
    t.string   "under_header"
    t.text     "keywords"
  end

  create_table "permission_values", force: true do |t|
    t.string   "permission_code"
    t.string   "code"
    t.string   "web_text"
    t.boolean  "from_aleph",      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", force: true do |t|
    t.string   "code"
    t.string   "web_text"
    t.boolean  "from_aleph", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",    default: true
    t.integer  "sort_order"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "sublibraries", force: true do |t|
    t.string   "code"
    t.string   "original_text"
    t.string   "web_text"
    t.boolean  "from_aleph",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",       default: true
    t.string   "under_header"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "firstname"
    t.string   "lastname"
    t.text     "user_attributes"
    t.datetime "refreshed_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
