class CreateEffectivePolls < ActiveRecord::Migration[6.0]
  def change
    create_table :polls do |t|
      t.string :title

      t.datetime :start_at
      t.datetime :end_at

      t.boolean :secret, default: false

      t.string :audience
      t.text :audience_scope

      t.datetime :updated_at
      t.datetime :created_at
    end

    create_table :poll_questions do |t|
      t.references :poll

      t.string :title
      t.string :category
      t.integer :position

      t.datetime :updated_at
      t.datetime :created_at
    end

    create_table :poll_question_options do |t|
      t.references :poll_question

      t.string :title
      t.integer :position

      t.datetime :updated_at
      t.datetime :created_at
    end

    create_table :ballots do |t|
      t.references :poll
      t.references :user

      t.string :token
      t.text :wizard_steps
      t.datetime :completed_at

      t.datetime :updated_at
      t.datetime :created_at
    end

    create_table :ballot_responses do |t|
      t.references :ballot
      t.references :poll
      t.references :poll_question
      t.references :poll_question_option

      t.date :date
      t.string :email
      t.integer :number
      t.text :long_answer
      t.text :short_answer

      t.datetime :updated_at
      t.datetime :created_at
    end

  end
end
