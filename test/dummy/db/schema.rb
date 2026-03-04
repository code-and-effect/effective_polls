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

ActiveRecord::Schema[8.1].define(version: 101) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.integer "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.string "content_type"
    t.datetime "created_at", precision: nil, null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ballots", force: :cascade do |t|
    t.datetime "completed_at", precision: nil
    t.datetime "created_at", precision: nil
    t.integer "poll_id"
    t.string "token"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.string "user_type"
    t.text "wizard_steps"
    t.index ["poll_id"], name: "index_ballots_on_poll_id"
    t.index ["user_type", "user_id"], name: "index_ballots_on_user_type_and_user_id"
  end

  create_table "email_templates", force: :cascade do |t|
    t.string "bcc"
    t.text "body"
    t.string "cc"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "from"
    t.string "subject"
    t.string "template_name"
    t.datetime "updated_at", null: false
  end

  create_table "poll_notifications", force: :cascade do |t|
    t.string "bcc"
    t.text "body"
    t.string "category"
    t.string "cc"
    t.datetime "completed_at", precision: nil
    t.string "content_type"
    t.datetime "created_at", precision: nil
    t.string "from"
    t.integer "poll_id"
    t.integer "reminder"
    t.datetime "started_at", precision: nil
    t.string "subject"
    t.datetime "updated_at", precision: nil
    t.index ["poll_id"], name: "index_poll_notifications_on_poll_id"
  end

  create_table "polls", force: :cascade do |t|
    t.string "audience"
    t.string "audience_class_name"
    t.text "audience_scope"
    t.datetime "created_at", precision: nil
    t.datetime "end_at", precision: nil
    t.boolean "hide_results", default: false
    t.boolean "skip_logging", default: false
    t.datetime "start_at", precision: nil
    t.string "title"
    t.string "token"
    t.datetime "updated_at", precision: nil
  end

  create_table "question_answers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
    t.date "date_begin"
    t.date "date_end"
    t.decimal "decimal"
    t.decimal "decimal_begin"
    t.decimal "decimal_end"
    t.string "email"
    t.text "long_answer"
    t.integer "number"
    t.integer "number_begin"
    t.integer "number_end"
    t.string "operation"
    t.integer "percentage"
    t.integer "percentage_begin"
    t.integer "percentage_end"
    t.integer "price"
    t.integer "price_begin"
    t.integer "price_end"
    t.integer "question_id"
    t.text "short_answer"
    t.datetime "updated_at", null: false
  end

  create_table "question_options", force: :cascade do |t|
    t.boolean "answer", default: false
    t.datetime "created_at", precision: nil
    t.integer "position"
    t.integer "question_id"
    t.string "title"
    t.datetime "updated_at", precision: nil
    t.index ["question_id"], name: "index_question_options_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", precision: nil
    t.boolean "follow_up", default: false
    t.string "follow_up_value"
    t.decimal "points"
    t.integer "position"
    t.integer "question_id"
    t.integer "question_option_id"
    t.integer "questionable_id"
    t.string "questionable_type"
    t.boolean "required", default: true
    t.boolean "scored", default: false
    t.string "task"
    t.string "title"
    t.datetime "updated_at", precision: nil
  end

  create_table "response_options", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "question_option_id"
    t.integer "response_id"
    t.datetime "updated_at", precision: nil
  end

  create_table "responses", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.date "date"
    t.decimal "decimal"
    t.string "email"
    t.text "long_answer"
    t.integer "number"
    t.integer "percentage"
    t.integer "price"
    t.integer "question_id"
    t.integer "questionable_id"
    t.string "questionable_type"
    t.integer "responsable_id"
    t.string "responsable_type"
    t.text "short_answer"
    t.datetime "updated_at", precision: nil
  end

  create_table "users", force: :cascade do |t|
    t.datetime "confirmation_sent_at", precision: nil
    t.datetime "confirmed_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip"
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.integer "roles_mask"
    t.integer "sign_in_count", default: 0, null: false
    t.string "unconfirmed_email"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
