# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2) do

  create_table "poll_question_options", force: :cascade do |t|
    t.integer "poll_question_id"
    t.string "title"
    t.integer "position"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.index ["poll_question_id"], name: "index_poll_question_options_on_poll_question_id"
  end

  create_table "poll_questions", force: :cascade do |t|
    t.integer "poll_id"
    t.string "title"
    t.string "category"
    t.integer "position"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.index ["poll_id"], name: "index_poll_questions_on_poll_id"
  end

  create_table "polls", force: :cascade do |t|
    t.string "title"
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean "secret", default: false
    t.string "audience"
    t.text "audience_scope"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "email", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "roles_mask"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end