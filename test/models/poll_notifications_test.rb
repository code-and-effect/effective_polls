require 'test_helper'

class PollNotificationsTest < ActiveSupport::TestCase
  test 'is notifiable when start_at blank and completed_at blank' do
    notification = build_effective_poll_notification
    assert notification.notifiable?

    notification.assign_attributes(started_at: Time.zone.now)
    refute notification.notifiable?
  end

  test 'notify_now? when poll starts' do
    poll = create_effective_poll!
    notification = build_effective_poll_notification(poll: poll, category: 'When poll starts')

    assert poll.started?
    assert notification.notify_now?

    poll.update!(start_at: Time.zone.now + 1.minute)
    refute poll.started?
    refute notification.notify_now?

    poll.update!(start_at: Time.zone.now - 1.minute, end_at: Time.zone.now)
    refute poll.available?
    refute notification.notify_now?
  end

  test 'notify_now? when poll ends' do
    poll = create_effective_poll!
    notification = build_effective_poll_notification(poll: poll, category: 'When poll ends')

    refute poll.ended?
    refute notification.notify_now?

    poll.update!(end_at: Time.zone.now)
    assert poll.ended?
    assert notification.notify_now?
  end

  test 'notify_now? upcoming reminder' do
    poll = create_effective_poll!
    poll.update!(end_at: Time.zone.now + 10.years)

    notification = build_effective_poll_notification(poll: poll, category: 'Upcoming reminder')
    notification.reminder = 1.day.to_i

    assert poll.started?
    refute notification.notify_now?

    # Send it
    poll.update!(start_at: Time.zone.now + 1.day)
    refute poll.started?
    assert notification.notify_now?

    # Not yet.
    poll.update!(start_at: Time.zone.now + 1.day + 1.minute)
    refute poll.started?
    refute notification.notify_now?

    # Shoulda sent this 10 minutes ago
    poll.update!(start_at: Time.zone.now + 1.day - 10.minute)
    refute poll.started?
    assert notification.notify_now?

    poll.update!(start_at: Time.zone.now - 1.minute, end_at: Time.zone.now)
    assert poll.ended?
    refute notification.notify_now?
  end

  test 'notify_now? reminder' do
    poll = create_effective_poll!
    poll.update!(start_at: Time.zone.now, end_at: Time.zone.now + 10.years)

    notification = build_effective_poll_notification(poll: poll, category: 'Reminder')
    notification.reminder = 1.day.to_i

    # It just started. Don't send.
    assert poll.available?
    refute notification.notify_now?

    # It's been one full day. Send it.
    poll.update!(start_at: Time.zone.now - 1.day)
    assert poll.available?
    assert notification.notify_now?

    # It hasn't been a full day yet. Don't send.
    poll.update!(start_at: Time.zone.now - 1.day + 1.minute)
    assert poll.available?
    refute notification.notify_now?

    # It's been a day and 10 minutes. Shoudla sent this 10 minutes ago. Send it.
    poll.update!(start_at: Time.zone.now - 1.day - 10.minute)
    assert poll.available?
    assert notification.notify_now?

    poll.update!(start_at: Time.zone.now - 1.minute, end_at: Time.zone.now)
    refute poll.available?
    refute notification.notify_now?
  end

  test 'notify! when poll starts' do
    poll = create_effective_poll!
    users = 1.upto(Effective::PollNotification::BATCHSIZE * 2).to_a.map { create_user! }

    notification = create_effective_poll_notification!(poll: poll, category: 'When poll starts')

    assert_email(count: 2) { assert notification.notify! }
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

    assert_email(count: 2) { assert notification.notify! }
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

    assert_email(count: 2) { assert notification.notify! }
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

    assert_email(count: 2) { assert notification.notify! }
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

    assert_email(count: 1) { assert notification.notify! }
    assert notification.completed_at.present?

    emails = ActionMailer::Base.deliveries.last(1)
    assert_equal 1, emails.length
    assert_equal "Reminder subject", emails.last.subject

    assert_equal emails.last.bcc, users.last(3).map(&:email)
  end

end
