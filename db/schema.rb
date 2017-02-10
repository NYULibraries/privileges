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

ActiveRecord::Schema.define(version: 20170210163517) do

  create_table "application_details", force: :cascade do |t|
    t.string   "purpose",     limit: 255
    t.text     "description", limit: 65535
    t.text     "the_text",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patron_status_permissions", force: :cascade do |t|
    t.string   "patron_status_code",  limit: 255
    t.string   "sublibrary_code",     limit: 255
    t.integer  "permission_value_id", limit: 4
    t.boolean  "from_aleph",                      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",                         default: true
  end

  create_table "patron_statuses", force: :cascade do |t|
    t.string   "code",          limit: 255
    t.string   "original_text", limit: 255
    t.string   "web_text",      limit: 255
    t.text     "description",   limit: 65535
    t.boolean  "from_aleph",                  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",                     default: true
    t.string   "id_type",       limit: 255
    t.string   "under_header",  limit: 255
    t.text     "keywords",      limit: 65535
  end

  create_table "permission_values", force: :cascade do |t|
    t.string   "permission_code", limit: 255
    t.string   "code",            limit: 255
    t.text     "web_text",        limit: 65535
    t.boolean  "from_aleph",                    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", force: :cascade do |t|
    t.string   "code",       limit: 255
    t.string   "web_text",   limit: 255
    t.boolean  "from_aleph",             default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",                default: true
    t.integer  "sort_order", limit: 4
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "sublibraries", force: :cascade do |t|
    t.string   "code",          limit: 255
    t.string   "original_text", limit: 255
    t.string   "web_text",      limit: 255
    t.boolean  "from_aleph",                default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",                   default: true
    t.string   "under_header",  limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",           limit: 255
    t.string   "email",              limit: 255
    t.string   "firstname",          limit: 255
    t.string   "lastname",           limit: 255
    t.datetime "refreshed_at"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "provider",           limit: 255, default: "",    null: false
    t.string   "aleph_id",           limit: 255
    t.string   "institution_code",   limit: 255
    t.string   "patron_status",      limit: 255
    t.boolean  "admin",                          default: false
    t.integer  "sign_in_count",      limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip", limit: 255
    t.string   "last_sign_in_ip",    limit: 255
  end

  add_index "users", ["username", "provider"], name: "index_users_on_username_and_provider", unique: true, using: :btree

end
