module Effective
  class BallotResponse < ActiveRecord::Base
    belongs_to :ballot

    belongs_to :poll
    belongs_to :poll_question

    has_many :ballot_response_options, dependent: :delete_all
    has_many :poll_question_options, through: :ballot_response_options

    has_one_attached :upload_file

    effective_resource do
      # The response
      date            :date
      email           :string
      number          :integer
      long_answer     :text
      short_answer    :text

      timestamps
    end

    scope :completed, -> { where(ballot: Effective::Ballot.completed) }
    scope :deep, -> { includes(:ballot, :poll, :poll_question, :poll_question_options) }

    validates :poll, presence: true
    validates :ballot, presence: true
    validates :poll_question, presence: true

    # Sanity check. These shouldn't happen.
    validate(if: -> { poll.present? && ballot.present? }) do
      self.errors.add(:ballot, 'must match poll') unless ballot.poll_id == poll.id
    end

    validate(if: -> { poll.present? && poll_question.present? }) do
      self.errors.add(:poll_question, 'must match poll') unless poll_question.poll_id == poll.id
    end

    # validates :date, presence: true, if: -> { poll_question&.date? }
    # validates :email, presence: true, email: true, if: -> { poll_question&.email? }
    # validates :number, presence: true, if: -> { poll_question&.number? }
    # validates :long_answer, presence: true, if: -> { poll_question&.long_answer? }
    # validates :short_answer, presence: true, if: -> { poll_question&.short_answer? }
    # validates :upload_file, presence: true, if: -> { poll_question&.upload_file? }

    validates :poll_question_option_ids, if: -> { poll_question&.choose_one? },
      length: { maximum: 1, message: 'please choose 1 option only' }

    validates :poll_question_option_ids, if: -> { poll_question&.select_upto_1? },
      length: { maximum: 1, message: 'please select 1 option or fewer' }

    validates :poll_question_option_ids, if: -> { poll_question&.select_upto_2? },
      length: { maximum: 2, message: 'please select 2 options or fewer' }

    validates :poll_question_option_ids, if: -> { poll_question&.select_upto_3? },
      length: { maximum: 3, message: 'please select 3 options or fewer' }

    validates :poll_question_option_ids, if: -> { poll_question&.select_upto_4? },
      length: { maximum: 4, message: 'please select 4 options or fewer' }

    validates :poll_question_option_ids, if: -> { poll_question&.select_upto_5? },
      length: { maximum: 5, message: 'please select 5 options or fewer' }

    def to_s
      persisted? ? 'ballot reponse' : 'New Ballot Response'
    end

    def response
      return nil unless poll_question.present?

      return date if poll_question.date?
      return email if poll_question.email?
      return number if poll_question.number?
      return long_answer if poll_question.long_answer?
      return short_answer if poll_question.short_answer?
      return upload_file if poll_question.upload_file?

      return poll_question_options.first if poll_question.choose_one?
      return poll_question_options.first if poll_question.select_upto_1?
      return poll_question_options if poll_question.poll_question_option?

      raise('unknown response for unexpected poll question category')
    end

    def category_partial
      poll_question&.category_partial
    end

  end
end
