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

    poll.update!(start_at: Time.zone.now + 1.minute, end_at: nil)
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

  test 'notification validates liquid body' do
    with_effective_email_templates do
      notification = Effective::PollNotification.new
      refute notification.update(body: "Something {{ busted }", subject: "Also {{ busted }")

      assert notification.errors[:body].present?
      assert notification.errors[:subject].present?
    end
  end

end
