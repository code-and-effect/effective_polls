module Effective
  class PollsMailer < EffectivePolls.mailer_class
    layout EffectivePolls.mailer[:layout].presence || 'effective_polls_mailer_layout'

    def poll_upcoming_reminder(poll_notification, bcc)
      @assigns = effective_email_templates_assigns(poll_notification)

      mail(
        bcc: bcc,
        body: poll_notification.body,
        from: poll_notification.from,
        subject: poll_notification.subject
      )
    end

    def poll_when_poll_starts(poll_notification, bcc)
      @assigns = effective_email_templates_assigns(poll_notification)

      mail(
        bcc: bcc,
        body: poll_notification.body,
        from: poll_notification.from,
        subject: poll_notification.subject
      )
    end

    def poll_reminder(poll_notification, bcc)
      @assigns = effective_email_templates_assigns(poll_notification)

      mail(
        bcc: bcc,
        body: poll_notification.body,
        from: poll_notification.from,
        subject: poll_notification.subject
      )
    end

    def poll_when_poll_ends(poll_notification, bcc)
      @assigns = effective_email_templates_assigns(poll_notification)

      mail(
        bcc: bcc,
        body: poll_notification.body,
        from: poll_notification.from,
        subject: poll_notification.subject
      )
    end

    private

    # Only relevant if the effective_email_templates gem is present
    def effective_email_templates_assigns(poll_notification)
      poll = poll_notification.poll
      raise('expected poll to be persisted') unless poll&.persisted?

      {
        available_date: poll.available_date,
        title: poll.title,
        url: effective_polls.new_poll_ballot_url(poll)
      }
    end

  end
end
