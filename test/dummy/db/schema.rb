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

ActiveRecord::Schema.define(version: 3) do

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "ballot_response_options", force: :cascade do |t|
    t.integer "ballot_response_id"
    t.integer "poll_question_option_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.index ["ballot_response_id"], name: "index_ballot_response_options_on_ballot_response_id"
    t.index ["poll_question_option_id"], name: "index_ballot_response_options_on_poll_question_option_id"
  end

  create_table "ballot_responses", force: :cascade do |t|
    t.integer "ballot_id"
    t.integer "poll_id"
    t.integer "poll_question_id"
    t.date "date"
    t.string "email"
    t.integer "number"
    t.text "long_answer"
    t.text "short_answer"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.index ["ballot_id"], name: "index_ballot_responses_on_ballot_id"
    t.index ["poll_id"], name: "index_ballot_responses_on_poll_id"
    t.index ["poll_question_id"], name: "index_ballot_responses_on_poll_question_id"
  end

  create_table "ballots", force: :cascade do |t|
    t.integer "poll_id"
    t.integer "user_id"
    t.string "token"
    t.text "wizard_steps"
    t.datetime "completed_at"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.index ["poll_id"], name: "index_ballots_on_poll_id"
    t.index ["user_id"], name: "index_ballots_on_user_id"
  end

  create_table "poll_notifications", force: :cascade do |t|
    t.integer "poll_id"
    t.string "category"
    t.integer "reminder"
    t.string "subject"
    t.text "body"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.index ["poll_id"], name: "index_poll_notifications_on_poll_id"
  end

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
    t.boolean "required"
    t.integer "position"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.index ["poll_id"], name: "index_poll_questions_on_poll_id"
  end

  create_table "polls", force: :cascade do |t|
    t.string "title"
    t.string "token"
    t.datetime "start_at"
    t.datetime "end_at"
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
