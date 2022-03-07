module Effective
  class PollsMailer < EffectivePolls.parent_mailer_class

    include EffectiveMailer
    include EffectiveEmailTemplatesMailer if EffectivePolls.use_effective_email_templates

    def poll_upcoming_reminder(poll_notification, user)
      @assigns = effective_email_templates_assigns(poll_notification, user)

      mail(
        to: user.email,
        from: poll_notification.from,
        body: poll_notification.body,
        subject: poll_notification.subject
      )
    end

    def poll_when_poll_starts(poll_notification, user)
      @assigns = effective_email_templates_assigns(poll_notification, user)

      mail(
        to: user.email,
        from: poll_notification.from,
        body: poll_notification.body,
        subject: poll_notification.subject
      )
    end

    def poll_reminder(poll_notification, user)
      @assigns = effective_email_templates_assigns(poll_notification, user)

      mail(
        to: user.email,
        from: poll_notification.from,
        body: poll_notification.body,
        subject: poll_notification.subject
      )
    end

    def poll_before_poll_ends(poll_notification, user)
      @assigns = effective_email_templates_assigns(poll_notification, user)

      mail(
        to: user.email,
        from: poll_notification.from,
        body: poll_notification.body,
        subject: poll_notification.subject
      )
    end

    def poll_when_poll_ends(poll_notification, user)
      @assigns = effective_email_templates_assigns(poll_notification, user)

      mail(
        to: user.email,
        from: poll_notification.from,
        body: poll_notification.body,
        subject: poll_notification.subject
      )
    end

    private

    # Only relevant if the effective_email_templates gem is present
    def effective_email_templates_assigns(poll_notification, user)
      raise('expected an Effective::PollNotification') unless poll_notification.kind_of?(Effective::PollNotification)
      raise('expected a User') unless user.kind_of?(User)

      poll = poll_notification.poll
      raise('expected poll to be persisted') unless poll&.persisted?

      {
        subject: poll_notification.subject,
        available_date: poll.available_date,
        title: poll.title,
        url: effective_polls.poll_url(poll),
        user: {
          name: user.to_s,
          email: user.email
        }
      }
    end

  end
end
