module Effective
  class PollNotification < ActiveRecord::Base
    belongs_to :poll

    CATEGORIES = ['When poll starts', 'When poll ends', 'Reminder']

    REMINDERS = {
      '1 day' => 1.days.to_i,
      '2 days' => 2.days.to_i,
      '3 days' => 3.days.to_i,
      '4 days' => 4.days.to_i,
      '5 days' => 5.days.to_i,
      '6 days' => 6.days.to_i,
      '1 week' => 1.weeks.to_i
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
    validates :reminder, presence: true, if: -> { reminder? }
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
