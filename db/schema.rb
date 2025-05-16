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

ActiveRecord::Schema[7.2].define(version: 2025_05_15_184126) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "user_id", null: false
    t.bigint "session_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_comments_on_session_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "session_id", null: false
    t.bigint "user_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "currency", default: "usd", null: false
    t.string "status", null: false
    t.string "stripe_payment_intent_id"
    t.string "stripe_customer_id"
    t.string "card_brand"
    t.string "card_last4"
    t.datetime "paid_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_payments_on_session_id"
    t.index ["stripe_customer_id"], name: "index_payments_on_stripe_customer_id"
    t.index ["stripe_payment_intent_id"], name: "index_payments_on_stripe_payment_intent_id", unique: true
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.string "status", default: "pending", null: false
    t.bigint "user_id", null: false
    t.bigint "consultant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consultant_id", "start_time", "end_time"], name: "index_sessions_on_consultant_id_and_start_time_and_end_time"
    t.index ["consultant_id"], name: "index_sessions_on_consultant_id"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "client", null: false
    t.string "name", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "comments", "sessions"
  add_foreign_key "comments", "users"
  add_foreign_key "payments", "sessions"
  add_foreign_key "payments", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "sessions", "users", column: "consultant_id"
end
