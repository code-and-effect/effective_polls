module Effective
  class PollsMailer < EffectivePolls.mailer_class
    layout EffectivePolls.mailer[:layout].presence || 'effective_polls_mailer_layout'

    def poll_upcoming_reminder(poll_notification, bcc)
      mail(
        bcc: bcc,
        body: poll_notification.body,
        from: poll_notification.from,
        subject: poll_notification.subject
      )
    end

    def poll_when_poll_starts(poll_notification, bcc)
      mail(
        bcc: bcc,
        body: poll_notification.body,
        from: poll_notification.from,
        subject: poll_notification.subject
      )
    end

    def poll_reminder(poll_notification, bcc)
      mail(
        bcc: bcc,
        body: poll_notification.body,
        from: poll_notification.from,
        subject: poll_notification.subject
      )
    end

    def poll_when_poll_ends(poll_notification, bcc)
      mail(
        bcc: bcc,
        body: poll_notification.body,
        from: poll_notification.from,
        subject: poll_notification.subject
      )
    end

  end
end
