require 'test_helper'
require 'effective_email_templates/importer'

class PollNotificationsEmailTest < ActiveSupport::TestCase
  test 'notify! when poll starts liquid template' do
    poll = create_effective_poll!
    users = 1.upto(Effective::PollNotification::BATCHSIZE * 2).to_a.map { create_user! }

    notification = create_effective_poll_notification!(poll: poll, category: 'When poll starts')

    template = Effective::EmailTemplate.where(template_name: notification.email_template).first!
    notification.update!(body: template.body, subject: template.subject, from: template.from)
    assert notification.subject.include?("{{ title }}")

    with_effective_email_templates do
      assert_email(count: 2) { assert notification.notify! }
    end

    assert notification.started_at.present?
    assert notification.completed_at.present?

    emails = ActionMailer::Base.deliveries.last(2)
    assert_equal "#{poll.title} has started", emails.last.subject
    assert emails.last.body.include?("#{poll.token}/ballots/new")

    assert_equal emails.first.bcc, users.first(3).map(&:email)
    assert_equal emails.last.bcc, users.last(3).map(&:email)
  end

  test 'notify! when poll ends liquid template' do
    poll = create_effective_poll!
    poll.update!(start_at: Time.zone.now - 1.minute, end_at: Time.zone.now)
    users = 1.upto(Effective::PollNotification::BATCHSIZE * 2).to_a.map { create_user! }

    notification = create_effective_poll_notification!(poll: poll, category: 'When poll ends')

    template = Effective::EmailTemplate.where(template_name: notification.email_template).first!
    notification.update!(body: template.body, subject: template.subject, from: template.from)
    assert notification.subject.include?("{{ title }}")

    with_effective_email_templates do
      assert_email(count: 2) { assert notification.notify! }
    end

    assert notification.completed_at.present?

    emails = ActionMailer::Base.deliveries.last(2)
    assert_equal 2, emails.length
    assert_equal "#{poll.title} has ended", emails.last.subject
    assert emails.last.body.include?("The #{poll.title} poll has ended")

    assert_equal emails.first.bcc, users.first(3).map(&:email)
    assert_equal emails.last.bcc, users.last(3).map(&:email)
  end

  test 'notify! when upcoming reminder liquid template' do
    poll = create_effective_poll!
    poll.update!(start_at: Time.zone.now + 1.day, end_at: Time.zone.now + 2.days)
    users = 1.upto(Effective::PollNotification::BATCHSIZE * 2).to_a.map { create_user! }

    notification = create_effective_poll_notification!(poll: poll, category: 'Upcoming reminder')

    template = Effective::EmailTemplate.where(template_name: notification.email_template).first!
    notification.update!(body: template.body, subject: template.subject, from: template.from)
    assert notification.subject.include?("{{ title }}")

    with_effective_email_templates do
      assert_email(count: 2) { assert notification.notify! }
    end

    assert notification.completed_at.present?

    emails = ActionMailer::Base.deliveries.last(2)
    assert_equal 2, emails.length
    assert_equal "#{poll.title} is upcoming", emails.last.subject
    assert emails.last.body.include?("The #{poll.title} poll is upcoming")

    assert_equal emails.first.bcc, users.first(3).map(&:email)
    assert_equal emails.last.bcc, users.last(3).map(&:email)
  end

  test 'notify! when reminder liquid template' do
    poll = create_effective_poll!
    poll.update!(start_at: Time.zone.now - 1.day, end_at: Time.zone.now + 2.days)
    users = 1.upto(Effective::PollNotification::BATCHSIZE * 2).to_a.map { create_user! }

    notification = create_effective_poll_notification!(poll: poll, category: 'Reminder')

    template = Effective::EmailTemplate.where(template_name: notification.email_template).first!
    notification.update!(body: template.body, subject: template.subject, from: template.from)
    assert notification.subject.include?("{{ title }}")

    with_effective_email_templates do
      assert_email(count: 2) { assert notification.notify! }
    end

    assert notification.completed_at.present?

    emails = ActionMailer::Base.deliveries.last(2)
    assert_equal 2, emails.length
    assert_equal "Reminder - Please submit your ballot for #{poll.title}", emails.last.subject
    assert emails.last.body.include?("The #{poll.title} poll has already started.")

    assert_equal emails.first.bcc, users.first(3).map(&:email)
    assert_equal emails.last.bcc, users.last(3).map(&:email)
  end

end
