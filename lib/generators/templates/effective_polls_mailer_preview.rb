# Visit http://localhost:3000/rails/mailers

class EffectivePollsMailerPreview < ActionMailer::Preview

  def poll_upcoming_reminder
    poll_notification = build_poll_notification('The poll will start soon')
    Effective::PollsMailer.poll_upcoming_reminder(poll_notification, bccs)
  end

  def poll_start
    poll_notification = build_poll_notification('The poll has started')
    Effective::PollsMailer.poll_start(poll_notification, bccs)
  end

  def poll_reminder
    poll_notification = build_poll_notification('The poll started already and you have not participated')
    Effective::PollsMailer.poll_reminder(poll_notification, bccs)
  end

  def poll_end
    poll_notification = build_poll_notification('The poll has ended')
    Effective::PollsMailer.poll_end(poll_notification, bccs)
  end

  protected

  def bccs
    ['one@example.com', 'two@example.com', 'three@example.com', 'two-hundred-fifty@example.com']
  end

  def build_poll_notification(text)
    poll = Effective::Poll.new(start_at: Time.zone.now)
    Effective::PollNotification.new(poll: poll, body: text, subject: text)
  end

end
