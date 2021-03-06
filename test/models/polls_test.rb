require 'test_helper'

class PollsTest < ActiveSupport::TestCase
  test 'create a valid poll' do
    poll = build_effective_poll()

    assert poll.valid?
    assert_equal Effective::PollQuestion::CATEGORIES, poll.poll_questions.map(&:category)
  end

  test 'a poll is started? once the start date has passed' do
    poll = create_effective_poll!
    poll.update_column(:start_at, Time.zone.now)
    assert poll.started?
  end

  test 'available?' do
    poll = create_effective_poll!

    poll.assign_attributes(start_at: Time.zone.now-1.minute, end_at: Time.zone.now+1.minute)
    poll.save(validate: false)
    assert poll.available?
    assert Effective::Poll.available.where(id: poll).exists?

    poll.assign_attributes(start_at: Time.zone.now-1.minute, end_at: nil)
    poll.save(validate: false)
    assert poll.available?
    assert Effective::Poll.available.where(id: poll).exists?

    poll.assign_attributes(start_at: Time.zone.now+1.minute, end_at: nil)
    poll.save(validate: false)
    refute poll.available?
    refute Effective::Poll.available.where(id: poll).exists?

    poll.assign_attributes(start_at: Time.zone.now, end_at: Time.zone.now-1.minute)
    poll.save(validate: false)
    refute poll.available?
    refute Effective::Poll.available.where(id: poll).exists?
  end

  test 'users' do
    poll = create_effective_poll!
    user = create_user!

    assert_equal 'All Users', poll.audience
    assert poll.users.include?(user)

    poll.update!(audience: 'Individual Users', audience_scope: [0])
    refute poll.users.include?(user)

    poll.update!(audience: 'Individual Users', audience_scope: [user.id])
    assert poll.users.include?(user)

    poll.update!(audience: 'Selected Users', audience_scope: [:first_name_test])
    assert poll.users.include?(user)

    poll.update!(audience: 'Selected Users', audience_scope: [:first_name_nil])
    refute poll.users.include?(user)

    poll.update!(audience: 'Selected Users', audience_scope: [:first_name_nil, :last_name_user])
    assert poll.users.include?(user)

    poll.update!(audience: 'Selected Users', audience_scope: [:first_name_test, :last_name_nil])
    assert poll.users.include?(user)

    poll.update!(audience: 'Selected Users', audience_scope: [:first_name_nil, :last_name_nil])
    refute poll.users.include?(user)
  end

  test 'audience emails' do
    poll = create_effective_poll!
    users = [create_user!, create_user!, create_user!]
    assert_equal users.map(&:email), poll.users(except_completed: false).pluck(:email)
    assert_equal users.map(&:email), poll.users(except_completed: true).pluck(:email)

    ballot = create_effective_ballot!(poll: poll, user: users.first)
    assert_equal users.map(&:email), poll.users(except_completed: false).pluck(:email)
    assert_equal users.map(&:email), poll.users(except_completed: true).pluck(:email)

    ballot.submit!
    assert_equal users.map(&:email), poll.users(except_completed: false).pluck(:email)
    assert_equal users.last(2).map(&:email), poll.users(except_completed: true).pluck(:email)
  end

end
