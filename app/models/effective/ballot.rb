module Effective
  class Ballot < ActiveRecord::Base
    attr_accessor :current_user

    belongs_to :poll
    belongs_to :user

    has_many :ballot_responses, -> { order(:id) }, inverse_of: :ballot, dependent: :delete_all
    accepts_nested_attributes_for :ballot_responses

    acts_as_tokened

    acts_as_wizard(
      start: 'Start',
      vote: 'Ballot',
      review: 'Review',
      complete: 'Complete'
    )

    effective_resource do
      # Acts as tokened
      token                  :string, permitted: false

      # Acts as Wizard
      wizard_steps           :text, permitted: false

      # More fields
      completed_at           :datetime, permitted: false

      timestamps
    end

    scope :deep, -> { includes(:poll, :user) }
    scope :sorted, -> { order(:id) }

    validates :user_id, uniqueness: {
      scope: :poll_id, allow_blank: true, message: 'your ballot already exists for this poll'
    }

    before_validation(if: -> { new_record? }) do
      self.user ||= current_user
    end

    def to_s
      persisted? ? "Ballot ##{id}" : 'New Ballot'
    end

  end
end
