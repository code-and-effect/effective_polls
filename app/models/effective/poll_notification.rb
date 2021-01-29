module Effective
  class PollNotification < ActiveRecord::Base
    belongs_to :poll
    log_changes(to: :poll) if respond_to?(:log_changes)

    CATEGORIES = ['Upcoming reminder', 'When poll starts', 'Reminder', 'When poll ends']
    EMAIL_TEMPLATE_VARIABLES = ['available_date', 'title', 'url', 'user.name', 'user.email']

    UPCOMING_REMINDERS = {
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
      '3 weeks before' => 3.weeks.to_i,
      '1 month before' => 1.month.to_i
    }

    REMINDERS = {
      '1 hour after' => 1.hours.to_i,
      '3 hours after' => 3.hours.to_i,
      '6 hours after' => 6.hours.to_i,
      '12 hours after' => 12.hours.to_i,
      '1 day after' => 1.days.to_i,
      '2 days after' => 2.days.to_i,
      '3 days after' => 3.days.to_i,
      '4 days after' => 4.days.to_i,
      '5 days after' => 5.days.to_i,
      '6 days after' => 6.days.to_i,
      '1 week after' => 1.weeks.to_i,
      '2 weeks after' => 2.weeks.to_i,
      '3 weeks after' => 3.weeks.to_i,
      '1 month after' => 1.month.to_i
    }

    effective_resource do
      category          :string
      reminder          :integer  # Number of seconds before poll.start_at

      # Email
      from              :string
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

    # Called by the poll_notifier rake task
    scope :notifiable, -> { where(started_at: nil, completed_at: nil) }

    validates :poll, presence: true
    validates :category, presence: true, inclusion: { in: CATEGORIES }

    validates :from, presence: true
    validates :subject, presence: true
    validates :body, presence: true

    if EffectivePolls.use_effective_email_templates
      validates :body, liquid: true
      validates :subject, liquid: true
    end

    validates :reminder, if: -> { reminder? || upcoming_reminder? },
      presence: true, uniqueness: { scope: [:poll_id, :category], message: 'already exists' }

    def to_s
      'poll notification'
    end

    def email_template
      'poll_' + category.to_s.parameterize.underscore
    end

    def upcoming_reminder?
      category == 'Upcoming reminder'
    end

    def poll_start?
      category == 'When poll starts'
    end

    def reminder?
      category == 'Reminder'
    end

    def poll_end?
      category == 'When poll ends'
    end

    def notifiable?
      started_at.blank? && completed_at.blank?
    end

    def notify_now?
      return false unless notifiable?

      case category
      when 'When poll starts'
        poll.available?
      when 'When poll ends'
        poll.ended?
      when 'Upcoming reminder'
        !poll.started? && poll.start_at < (Time.zone.now + reminder)
      when 'Reminder'
        !poll.ended? && poll.start_at < (Time.zone.now - reminder)
      else
        raise('unexpected category')
      end
    end

    def notify!
      return false unless notify_now?

      # We send to all users, except for the 'Reminder' that exclude completed users
      users = poll.users(except_completed: (category == 'Reminder'))

      update_column(:started_at, Time.zone.now)

      users.find_each do |user|
        Effective::PollsMailer.public_send(email_template, self, user).deliver_now
      end

      update_column(:completed_at, Time.zone.now)
    end

  end
end
