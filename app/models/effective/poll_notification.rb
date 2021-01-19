module Effective
  class PollNotification < ActiveRecord::Base
    belongs_to :poll

    CATEGORIES = ['When poll starts', 'When poll ends', 'Reminder']

    REMINDERS = {
      '1 hour before' => 1.hours.to_i,
      '3 hours before' => 3.hours.to_i,
      '6 hours before' => 6.hours.to_i,
      '12 hours before' => 12.hours.to_i,
      '1 day before' => 1.days.to_i,
      '2 days before' => 2.days.to_i,
      '3 days before' => 3.days.to_i,
      '4 days before' => 4.days.to_i,
      '5 days before' => 5.days.to_i,
      '6 days before' => 6.days.to_i,
      '1 week before' => 1.weeks.to_i,
      '2 weeks before' => 2.weeks.to_i,
      '1 month before' => 1.month.to_i
    }

    effective_resource do
      category          :string
      reminder          :integer  # Number of seconds before poll.start_at

      # Email
      subject           :string
      body              :text

      # Tracking background jobs email send out
      started_at        :datetime
      completed_at      :datetime

      timestamps
    end

    scope :sorted, -> { order(:id) }
    scope :deep, -> { includes(:poll) }

    scope :started, -> { where.not(started_at: nil) }
    scope :completed, -> { where.not(completed_at: nil) }

    validates :poll, presence: true
    validates :category, presence: true, inclusion: { in: CATEGORIES }
    validates :reminder, presence: true, if: -> { reminder? }, uniqueness: { scope: [:poll_id], message: 'already exists' }
    validates :subject, presence: true
    validates :body, presence: true

    def to_s
      'poll notification'
    end

    def poll_start?
      category == 'When poll starts'
    end

    def poll_end?
      category == 'When poll ends'
    end

    def reminder?
      category == 'Reminder'
    end

  end
end
