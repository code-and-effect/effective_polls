require 'test_helper'
require 'effective_email_templates/importer'

class PollNotificationsEmailTest < ActiveSupport::TestCase
  test 'notify! when poll starts liquid template' do
    with_effective_email_templates do
      poll = create_effective_poll!
      users = [create_user!, create_user!]

      notification = create_effective_poll_notification!(poll: poll, category: 'When poll starts')

      template = Effective::EmailTemplate.where(template_name: notification.email_template).first!
      notification.update!(body: template.body, subject: template.subject, from: template.from)
      assert notification.subject.include?("{{ title }}")

      assert_email(count: 2) { assert notification.notify! }

      assert notification.started_at.present?
      assert notification.completed_at.present?

      email = ActionMailer::Base.deliveries.last
      assert_equal "#{poll.title} has started", email.subject
      assert email.body.include?("polls/#{poll.token}")
      assert email.body.include?("Hello #{users.last}")
    end
  end

  test 'notify! when poll ends liquid template' do
    with_effective_email_templates do
      poll = create_effective_poll!
      poll.update!(start_at: Time.zone.now - 1.minute, end_at: Time.zone.now)
      users = [create_user!, create_user!]

      notification = create_effective_poll_notification!(poll: poll, category: 'When poll ends')

      template = Effective::EmailTemplate.where(template_name: notification.email_template).first!
      notification.update!(body: template.body, subject: template.subject, from: template.from)
      assert notification.subject.include?("{{ title }}")

      assert_email(count: 2) { assert notification.notify! }

      assert notification.started_at.present?
      assert notification.completed_at.present?

      email = ActionMailer::Base.deliveries.last
      assert_equal "#{poll.title} has ended", email.subject
      assert email.body.include?("The #{poll.title} poll has ended")
      assert email.body.include?("Hello #{users.last}")
    end
  end

  test 'notify! when upcoming reminder liquid template' do
    with_effective_email_templates do
      poll = create_effective_poll!
      poll.update!(start_at: Time.zone.now + 1.day, end_at: Time.zone.now + 2.days)
      users = [create_user!, create_user!]

      notification = create_effective_poll_notification!(poll: poll, category: 'Upcoming reminder')

      template = Effective::EmailTemplate.where(template_name: notification.email_template).first!
      notification.update!(body: template.body, subject: template.subject, from: template.from)
      assert notification.subject.include?("{{ title }}")

      assert_email(count: 2) { assert notification.notify! }

      assert notification.started_at.present?
      assert notification.completed_at.present?

      email = ActionMailer::Base.deliveries.last
      assert_equal "#{poll.title} is upcoming", email.subject
      assert email.body.include?("The #{poll.title} poll is upcoming")
      assert email.body.include?("Hello #{users.last}")
    end
  end

  test 'notify! when reminder liquid template' do
    with_effective_email_templates do
      poll = create_effective_poll!
      poll.update!(start_at: Time.zone.now - 1.day, end_at: Time.zone.now + 2.days)
      users = [create_user!, create_user!]

      notification = create_effective_poll_notification!(poll: poll, category: 'Reminder')

      template = Effective::EmailTemplate.where(template_name: notification.email_template).first!
      notification.update!(body: template.body, subject: template.subject, from: template.from)
      assert notification.subject.include?("{{ title }}")

      assert_email(count: 2) { assert notification.notify! }

      assert notification.started_at.present?
      assert notification.completed_at.present?

      email = ActionMailer::Base.deliveries.last
      assert_equal "Reminder - Please submit your ballot for #{poll.title}", email.subject
      assert email.body.include?("The #{poll.title} poll has already started")
      assert email.body.include?("Hello #{users.last}")
    end
  end

  test 'notify! when before poll ends liquid template' do
    with_effective_email_templates do
      poll = create_effective_poll!
      poll.update!(start_at: Time.zone.now - 1.day, end_at: Time.zone.now + 1.day)
      users = [create_user!, create_user!]

      notification = create_effective_poll_notification!(poll: poll, category: 'Before poll ends')

      template = Effective::EmailTemplate.where(template_name: notification.email_template).first!
      notification.update!(body: template.body, subject: template.subject, from: template.from)
      assert notification.subject.include?("{{ title }}")

      assert_email(count: 2) { assert notification.notify! }

      assert notification.started_at.present?
      assert notification.completed_at.present?

      email = ActionMailer::Base.deliveries.last
      assert_equal "Please submit your ballot for #{poll.title}", email.subject
      assert email.body.include?("The #{poll.title} poll is almost complete")
      assert email.body.include?("Hello #{users.last}")
    end
  end

end
