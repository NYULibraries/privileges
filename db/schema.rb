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

ActiveRecord::Schema.define(version: 2017_02_10_163517) do

  create_table "application_details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "purpose"
    t.text "description"
    t.text "the_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patron_status_permissions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "patron_status_code"
    t.string "sublibrary_code"
    t.integer "permission_value_id"
    t.boolean "from_aleph", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "visible", default: true
  end

  create_table "patron_statuses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code"
    t.string "original_text"
    t.string "web_text"
    t.text "description"
    t.boolean "from_aleph", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "visible", default: true
    t.string "id_type"
    t.string "under_header"
    t.text "keywords"
  end

  create_table "permission_values", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "permission_code"
    t.string "code"
    t.text "web_text"
    t.boolean "from_aleph", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code"
    t.string "web_text"
    t.boolean "from_aleph", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "visible", default: true
    t.integer "sort_order"
  end

  create_table "sessions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "sublibraries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code"
    t.string "original_text"
    t.string "web_text"
    t.boolean "from_aleph", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "visible", default: true
    t.string "under_header"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "firstname"
    t.string "lastname"
    t.datetime "refreshed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider", default: "", null: false
    t.string "aleph_id"
    t.string "institution_code"
    t.string "patron_status"
    t.boolean "admin", default: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["username", "provider"], name: "index_users_on_username_and_provider", unique: true
  end

end
