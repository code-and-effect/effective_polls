module Effective
  class Ballot < ApplicationRecord
    attr_accessor :current_user

    belongs_to :poll, class_name: 'Effective::Poll'
    belongs_to :user

    acts_as_wizard(
      start: 'Start',
      vote: 'Ballot',
      review: 'Review',
      complete: 'Complete'
    )

    effective_resource do
      # Acts as Wizard
      wizard_steps           :text, permitted: false

      # More fields
      completed_at           :datetime

      timestamps
    end

    scope :deep, -> { includes(:poll, :user) }
    scope :sorted, -> { order(:id) }

    validates :user_id, uniqueness: {
      scope: :poll_id, allow_blank: true, message: 'a ballot already exists for this poll and user'
    }

    before_validation(if: -> { new_record? }) do
      self.user ||= current_user
    end

    def to_s
      persisted? ? "Ballot ##{id}" : 'New Ballot'
    end

  end
end
