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

ActiveRecord::Schema[7.1].define(version: 2025_06_18_055753) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "log_entries", force: :cascade do |t|
    t.text "content"
    t.integer "entry_type"
    t.string "section_identifier"
    t.boolean "is_editable_section"
    t.bigint "log_id", null: false
    t.bigint "user_id", null: false
    t.bigint "previous_entry_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["log_id"], name: "index_log_entries_on_log_id"
    t.index ["previous_entry_id"], name: "index_log_entries_on_previous_entry_id"
    t.index ["user_id"], name: "index_log_entries_on_user_id"
  end

  create_table "logs", force: :cascade do |t|
    t.date "date"
    t.string "title"
    t.integer "status"
    t.bigint "unit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "unit_id"], name: "index_logs_on_date_and_unit_id", unique: true
    t.index ["unit_id"], name: "index_logs_on_unit_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "log_entries", "log_entries", column: "previous_entry_id"
  add_foreign_key "log_entries", "logs"
  add_foreign_key "log_entries", "users"
  add_foreign_key "logs", "units"
end
