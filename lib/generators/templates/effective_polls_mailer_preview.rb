# Visit http://localhost:3000/rails/mailers

class EffectivePollsMailerPreview < ActionMailer::Preview

  def poll_upcoming_reminder
    poll_notification = build_poll_notification('The poll will start soon')
    Effective::PollsMailer.poll_upcoming_reminder(poll_notification, build_user)
  end

  def poll_start
    poll_notification = build_poll_notification('The poll has started')
    Effective::PollsMailer.poll_start(poll_notification, build_user)
  end

  def poll_reminder
    poll_notification = build_poll_notification('The poll started already and you have not participated')
    Effective::PollsMailer.poll_reminder(poll_notification, build_user)
  end

  def poll_end
    poll_notification = build_poll_notification('The poll has ended')
    Effective::PollsMailer.poll_end(poll_notification, build_user)
  end

  protected

  def build_user
    User.new(email: 'buyer@website.com').tap do |user|
      user.name = 'Valued Customer' if user.respond_to?(:name=)
      user.full_name = 'Valued Customer' if user.respond_to?(:full_name=)

      if user.respond_to?(:first_name=) && user.respond_to?(:last_name=)
        user.first_name = 'Valued'
        user.last_name = 'Customer'
      end
    end
  end

  def build_poll_notification(text)
    poll = Effective::Poll.new(start_at: Time.zone.now)
    Effective::PollNotification.new(poll: poll, body: text, subject: text)
  end

end
