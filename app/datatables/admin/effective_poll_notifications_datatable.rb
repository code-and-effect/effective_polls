class Admin::EffectivePollNotificationsDatatable < Effective::Datatable
  filters do
    scope :all
    scope :started
    scope :completed
  end

  datatable do
    col :updated_at, visible: false
    col :created_at, visible: false
    col :id, visible: false

    col :poll
    col :category

    col :reminder do |poll_notification|
      case poll_notification.category
      when 'When poll starts'
        poll_notification.poll.start_at&.strftime('%F %H:%M')
      when 'When poll ends'
        poll_notification.poll.end_at&.strftime('%F %H:%M')
      when 'Upcoming reminder'
        Effective::PollNotification::UPCOMING_REMINDERS.invert[poll_notification.reminder]
      when 'Reminder'
        Effective::PollNotification::REMINDERS.invert[poll_notification.reminder]
      when 'Before poll ends'
        Effective::PollNotification::UPCOMING_REMINDERS.invert[poll_notification.reminder]
      else
        raise('unexpected category')
      end
    end

    col :subject
    col :body

    col :started_at, visible: false
    col :completed_at

    actions_col
  end

  collection do
    Effective::PollNotification.all.deep
  end
end
