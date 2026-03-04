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

      t.boolean :scored, default: false

      t.string :task
      t.decimal :points

      t.datetime :updated_at
      t.datetime :created_at
    end

    create_table :question_options do |t|
      t.references :question, polymorphic: false

      t.string :title
      t.integer :position

      t.boolean :answer, default: false

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
      t.decimal :decimal
      t.integer :percentage
      t.integer :price

      t.datetime :updated_at
      t.datetime :created_at
    end

    create_table :response_options do |t|
      t.integer :response_id
      t.integer :question_option_id

      t.datetime :updated_at
      t.datetime :created_at
    end

    create_table :question_answers do |t|
      t.integer :question_id

      t.string :operation

      t.date :date
      t.date :date_begin
      t.date :date_end

      t.decimal :decimal
      t.decimal :decimal_begin
      t.decimal :decimal_end

      t.string :email

      t.integer :number
      t.integer :number_begin
      t.integer :number_end

      t.integer :percentage
      t.integer :percentage_begin
      t.integer :percentage_end

      t.integer :price
      t.integer :price_begin
      t.integer :price_end

      t.text :long_answer
      t.text :short_answer

      t.timestamps
    end

  end
end
