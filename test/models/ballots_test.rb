require 'test_helper'

class BallotsTest < ActiveSupport::TestCase
  test 'create a valid ballot' do
    ballot = create_effective_ballot!
    assert ballot.valid?
    assert ballot.poll.valid?
  end

  test 'ballot is unique per user per poll' do
    poll = create_effective_poll!
    user = create_user!
    ballot = create_effective_ballot!(poll: poll, user: user)
    assert ballot.valid?

    ballot2 = build_effective_ballot(poll: poll, user: user)
    refute ballot2.valid?
    assert ballot2.errors[:user_id].present?
  end

  test 'submit! means completed' do
    ballot = build_effective_ballot
    ballot.submit!
    assert ballot.completed?
  end

end
