class CreateEffectivePolls < ActiveRecord::Migration[6.0]
  def change
    create_table :polls do |t|
      t.string :title

      t.string :token
      t.datetime :start_at
      t.datetime :end_at

      t.string :audience

      t.string :audience_class_name
      t.text :audience_scope

      t.boolean :hide_results, default: false
      t.boolean :skip_logging, default: false

      t.datetime :updated_at
      t.datetime :created_at
    end

    create_table :poll_notifications do |t|
      t.references :poll, polymorphic: false

      t.string :category
      t.integer :reminder

      t.string :from
      t.string :subject
      t.text :body

      t.datetime :started_at
      t.datetime :completed_at

      t.datetime :updated_at
      t.datetime :created_at
    end

    create_table :poll_questions do |t|
      t.references :poll, polymorphic: false

      t.string :title
      t.string :category
      t.boolean :required, default: true

      t.integer :position

      t.datetime :updated_at
      t.datetime :created_at
    end

    create_table :poll_question_options do |t|
      t.references :poll_question, polymorphic: false

      t.string :title
      t.integer :position

      t.datetime :updated_at
      t.datetime :created_at
    end

    create_table :ballots do |t|
      t.references :poll, polymorphic: false
      t.references :user, polymorphic: true

      t.string :token
      t.text :wizard_steps
      t.datetime :completed_at

      t.datetime :updated_at
      t.datetime :created_at
    end

    create_table :ballot_responses do |t|
      t.references :ballot, polymorphic: false
      t.references :poll, polymorphic: false
      t.references :poll_question, polymorphic: false

      t.date :date
      t.string :email
      t.integer :number
      t.text :long_answer
      t.text :short_answer

      t.datetime :updated_at
      t.datetime :created_at
    end

    create_table :ballot_response_options do |t|
      t.references :ballot_response, polymorphic: false
      t.references :poll_question_option, polymorphic: false

      t.datetime :updated_at
      t.datetime :created_at
    end

  end
end
