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

  test 'a poll is read only after started' do
    poll = create_effective_poll!
    poll.update_column(:start_at, Time.zone.now)
    assert poll.started?

    refute poll.update(title: 'Something else')
    assert poll.errors[:base].first.include?('has already started')
  end


end
