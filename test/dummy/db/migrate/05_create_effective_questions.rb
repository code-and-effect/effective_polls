class CreateEffectiveQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.integer :questionable_id
      t.string :questionable_type

      t.string :title
      t.string :category
      t.boolean :required, default: true

      t.integer :position

      t.boolean :follow_up, default: false
      t.string :follow_up_value

      t.integer :question_id
      t.integer :question_option_id

      t.datetime :updated_at
      t.datetime :created_at
    end

    create_table :question_options do |t|
      t.references :question, polymorphic: false

      t.string :title
      t.integer :position

      t.datetime :updated_at
      t.datetime :created_at
    end

    create_table :responses do |t|
      t.integer :questionable_id
      t.string :questionable_type

      t.integer :responsable_id
      t.string :responsable_type

      t.integer :question_id

      t.date :date
      t.string :email
      t.integer :number
      t.text :long_answer
      t.text :short_answer

      t.datetime :updated_at
      t.datetime :created_at
    end

    create_table :response_options do |t|
      t.integer :response_id
      t.integer :question_option_id

      t.datetime :updated_at
      t.datetime :created_at
    end
  end
end
