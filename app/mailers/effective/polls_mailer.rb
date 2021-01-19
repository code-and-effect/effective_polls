module Effective
  class PollsMailer < ActionMailer::Base
    default from: EffectivePolls.mailer[:default_from]
    layout EffectivePolls.mailer[:layout].presence || 'effective_polls_mailer_layout'

    def poll_upcoming_reminder(poll_notification, bcc)
      mail(bcc: bcc, body: poll_notification.body, subject: poll_notification.subject)
    end

    def poll_start(poll_notification, bcc)
      mail(bcc: bcc, body: poll_notification.body, subject: poll_notification.subject)
    end

    def poll_reminder(poll_notification, bcc)
      mail(bcc: bcc, body: poll_notification.body, subject: poll_notification.subject)
    end

    def poll_end(poll_notification, bcc)
      mail(bcc: bcc, body: poll_notification.body, subject: poll_notification.subject)
    end

  end
end
