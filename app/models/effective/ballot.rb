module Effective
  class Ballot < ActiveRecord::Base
    attr_accessor :current_user
    attr_accessor :current_step

    # Application namespace
    belongs_to :user, polymorphic: true

    # Effective namespace
    belongs_to :poll

    has_many :ballot_responses, dependent: :destroy
    accepts_nested_attributes_for :ballot_responses, allow_destroy: true

    acts_as_tokened

    log_changes(to: :poll) if respond_to?(:log_changes)

    acts_as_wizard(
      start: 'Start',
      vote: 'Ballot',
      submit: 'Review',     # They submit on this step
      complete: 'Complete'
    )

    effective_resource do
      # Acts as tokened
      token                  :string, permitted: false

      # Acts as Wizard
      wizard_steps           :text, permitted: false

      # More fields
      completed_at           :datetime, permitted: false

      current_step           permitted: true
      timestamps
    end

    scope :deep, -> { includes(:poll, :user, ballot_responses: [:poll, :poll_question, :poll_question_options]) }
    scope :sorted, -> { order(:id) }

    scope :in_progress, -> { where(completed_at: nil) }
    scope :done, -> { where.not(completed_at: nil) }

    scope :completed, -> { where.not(completed_at: nil) }

    before_validation(if: -> { new_record? }) do
      self.user ||= current_user
    end

    validates :user_id, uniqueness: {
      scope: :poll_id, allow_blank: true, message: 'ballot already exists for this poll'
    }

    # I seem to need this even tho I accept_nested_attributes
    validates :ballot_responses, associated: true

    def to_s
      model_name.human
    end

    # Disable effective_logging log_changes for this resource
    def log_changes?
      return false if poll&.skip_logging?
      true
    end

    # Find or build
    def ballot_response(poll_question)
      ballot_response = ballot_responses.find { |br| br.poll_question_id == poll_question.id }
      ballot_response ||= ballot_responses.build(poll: poll_question.poll, poll_question: poll_question)
    end

    # This is the review step where they click Submit Ballot
    def submit!
      wizard_steps[:complete] ||= Time.zone.now
      self.completed_at ||= Time.zone.now

      save!
    end

    def completed?
      completed_at.present?
    end

  end
end
