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

  test 'response is required when question is required' do
    poll = create_effective_poll!
    poll_question = poll.poll_questions.first
    poll_question.update!(required: true)

    ballot = build_effective_ballot(poll: poll)
    refute ballot.valid?

    ballot_response = ballot.ballot_response(poll_question)
    assert ballot_response.errors.present?
  end

  test 'cannot revisit previous steps once completed' do
    ballot = build_effective_ballot
    assert ballot.can_visit_step?(:start)

    ballot.wizard_steps[:start] = Time.zone.now
    assert ballot.can_visit_step?(:start)
    assert ballot.can_visit_step?(:vote)

    ballot.wizard_steps[:vote] = Time.zone.now
    assert ballot.can_visit_step?(:start)
    assert ballot.can_visit_step?(:vote)
    assert ballot.can_visit_step?(:submit)

    ballot.submit!
    refute ballot.can_visit_step?(:start)
    refute ballot.can_visit_step?(:vote)
    refute ballot.can_visit_step?(:submit)
    assert ballot.can_visit_step?(:complete)
  end

end
