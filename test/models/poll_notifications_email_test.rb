require 'test_helper'

class PollNotificationsEmailTest < ActiveSupport::TestCase
  test 'notify! when poll starts' do
    without_effective_email_templates do
      poll = create_effective_poll!
      users = [create_user!, create_user!]

      notification = create_effective_poll_notification!(poll: poll, category: 'When poll starts')
      assert_email(count: 2) { assert notification.notify! }

      assert notification.started_at.present?
      assert notification.completed_at.present?

      email = ActionMailer::Base.deliveries.last
      assert_equal "When poll starts subject", email.subject
    end
  end

  test 'notify! when poll ends' do
    without_effective_email_templates do
      poll = create_effective_poll!
      poll.update!(start_at: Time.zone.now - 1.minute, end_at: Time.zone.now)
      users = [create_user!, create_user!]

      notification = create_effective_poll_notification!(poll: poll, category: 'When poll ends')
      assert_email(count: 2) { assert notification.notify! }

      assert notification.started_at.present?
      assert notification.completed_at.present?

      email = ActionMailer::Base.deliveries.last
      assert_equal "When poll ends subject", email.subject
    end
  end

  test 'notify! when upcoming reminder' do
    without_effective_email_templates do
      poll = create_effective_poll!
      poll.update!(start_at: Time.zone.now + 1.day, end_at: Time.zone.now + 2.days)
      users = [create_user!, create_user!]

      notification = create_effective_poll_notification!(poll: poll, category: 'Upcoming reminder')
      assert_email(count: 2) { assert notification.notify! }

      assert notification.started_at.present?
      assert notification.completed_at.present?

      email = ActionMailer::Base.deliveries.last
      assert_equal "Upcoming reminder subject", email.subject
    end
  end

  test 'notify! when reminder' do
    without_effective_email_templates do
      poll = create_effective_poll!
      poll.update!(start_at: Time.zone.now - 1.day, end_at: Time.zone.now + 2.days)
      users = [create_user!, create_user!]

      notification = create_effective_poll_notification!(poll: poll, category: 'Reminder')
      assert_email(count: 2) { assert notification.notify! }

      assert notification.started_at.present?
      assert notification.completed_at.present?

      email = ActionMailer::Base.deliveries.last
      assert_equal "Reminder subject", email.subject
    end
  end

  test 'notify! when reminder with ballots' do
    without_effective_email_templates do
      poll = create_effective_poll!
      poll.update!(start_at: Time.zone.now - 1.day, end_at: Time.zone.now + 2.days)
      users = [create_user!, create_user!]

      create_effective_ballot!(poll: poll, user: users.first).submit!

      notification = create_effective_poll_notification!(poll: poll, category: 'Reminder')
      assert_email(count: 1) { assert notification.notify! }

      assert notification.started_at.present?
      assert notification.completed_at.present?

      email = ActionMailer::Base.deliveries.last
      assert_equal "Reminder subject", email.subject
      assert_equal [users.last.email], email.to
    end
  end

  test 'notify! when before poll ends with ballots' do
    without_effective_email_templates do
      poll = create_effective_poll!
      poll.update!(start_at: Time.zone.now - 1.day, end_at: Time.zone.now + 1.days)
      users = [create_user!, create_user!]

      create_effective_ballot!(poll: poll, user: users.first).submit!

      notification = create_effective_poll_notification!(poll: poll, category: 'Before poll ends')
      assert_email(count: 1) { assert notification.notify! }

      assert notification.started_at.present?
      assert notification.completed_at.present?

      email = ActionMailer::Base.deliveries.last
      assert_equal "Before poll ends subject", email.subject
      assert_equal [users.last.email], email.to
    end
  end


end
