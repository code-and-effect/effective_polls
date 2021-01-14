class BallotResponse < ActiveRecord::Base
  belongs_to :ballot

  belongs_to :poll
  belongs_to :poll_question
  belongs_to :poll_question_option, optional: true

  has_one_attached :upload_file

  effective_resource do
    date            :date
    email           :string
    number          :integer
    long_answer     :text
    short_answer    :text

    timestamps
  end

  validates :poll, presence: true
  validates :ballot, presence: true
  validates :poll_question, presence: true

  with_options(if: -> { poll_question.present? }) do
    validates :poll_question_option, presence: true, if: -> { poll_question.poll_question_option? }
    validates :date, presence: true, if: -> { poll_question.date? }
    validates :email, presence: true, email: true, if: -> { poll_question.email? }
    validates :number, presence: true, if: -> { poll_question.number? }
    validates :long_answer, presence: true, if: -> { poll_question.long_answer? }
    validates :short_answer, presence: true, if: -> { poll_question.short_answer? }
    validates :upload_file, presence: true, if: -> { poll_question.upload_file? }
  end

end
