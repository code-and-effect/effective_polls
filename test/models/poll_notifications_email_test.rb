require 'test_helper'

class PollNotificationsEmailTest < ActiveSupport::TestCase
  test 'notify! when poll starts' do
    poll = create_effective_poll!
    users = 1.upto(Effective::PollNotification::BATCHSIZE * 2).to_a.map { create_user! }

    notification = create_effective_poll_notification!(poll: poll, category: 'When poll starts')

    without_email_templates do
      assert_email(count: 2) { assert notification.notify! }
    end

    assert notification.started_at.present?
    assert notification.completed_at.present?

    emails = ActionMailer::Base.deliveries.last(2)
    assert_equal 2, emails.length
    assert_equal "When poll starts subject", emails.last.subject

    assert_equal emails.first.bcc, users.first(3).map(&:email)
    assert_equal emails.last.bcc, users.last(3).map(&:email)
  end

  test 'notify! when poll ends' do
    poll = create_effective_poll!
    poll.update!(start_at: Time.zone.now - 1.minute, end_at: Time.zone.now)
    users = 1.upto(Effective::PollNotification::BATCHSIZE * 2).to_a.map { create_user! }

    notification = create_effective_poll_notification!(poll: poll, category: 'When poll ends')

    without_email_templates do
      assert_email(count: 2) { assert notification.notify! }
    end

    assert notification.completed_at.present?

    emails = ActionMailer::Base.deliveries.last(2)
    assert_equal 2, emails.length
    assert_equal "When poll ends subject", emails.last.subject

    assert_equal emails.first.bcc, users.first(3).map(&:email)
    assert_equal emails.last.bcc, users.last(3).map(&:email)
  end

  test 'notify! when upcoming reminder' do
    poll = create_effective_poll!
    poll.update!(start_at: Time.zone.now + 1.day, end_at: Time.zone.now + 2.days)
    users = 1.upto(Effective::PollNotification::BATCHSIZE * 2).to_a.map { create_user! }

    notification = create_effective_poll_notification!(poll: poll, category: 'Upcoming reminder')

    without_email_templates do
      assert_email(count: 2) { assert notification.notify! }
    end

    assert notification.completed_at.present?

    emails = ActionMailer::Base.deliveries.last(2)
    assert_equal 2, emails.length
    assert_equal "Upcoming reminder subject", emails.last.subject

    assert_equal emails.first.bcc, users.first(3).map(&:email)
    assert_equal emails.last.bcc, users.last(3).map(&:email)
  end

  test 'notify! when reminder' do
    poll = create_effective_poll!
    poll.update!(start_at: Time.zone.now - 1.day, end_at: Time.zone.now + 2.days)
    users = 1.upto(Effective::PollNotification::BATCHSIZE * 2).to_a.map { create_user! }

    notification = create_effective_poll_notification!(poll: poll, category: 'Reminder')

    without_email_templates do
      assert_email(count: 2) { assert notification.notify! }
    end

    assert notification.completed_at.present?

    emails = ActionMailer::Base.deliveries.last(2)
    assert_equal 2, emails.length
    assert_equal "Reminder subject", emails.last.subject

    assert_equal emails.first.bcc, users.first(3).map(&:email)
    assert_equal emails.last.bcc, users.last(3).map(&:email)
  end

  test 'notify! when reminder with ballots' do
    poll = create_effective_poll!
    poll.update!(start_at: Time.zone.now - 1.day, end_at: Time.zone.now + 2.days)
    users = 1.upto(Effective::PollNotification::BATCHSIZE * 2).to_a.map { create_user! }

    create_effective_ballot!(poll: poll, user: users.first).submit!
    create_effective_ballot!(poll: poll, user: users.second).submit!
    create_effective_ballot!(poll: poll, user: users.third).submit!

    notification = create_effective_poll_notification!(poll: poll, category: 'Reminder')

    without_email_templates do
      assert_email(count: 1) { assert notification.notify! }
    end

    assert notification.completed_at.present?

    emails = ActionMailer::Base.deliveries.last(1)
    assert_equal 1, emails.length
    assert_equal "Reminder subject", emails.last.subject

    assert_equal emails.last.bcc, users.last(3).map(&:email)
  end

end
