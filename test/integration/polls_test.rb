require 'test_helper'

module Effective
  class PollsTest < ActionDispatch::IntegrationTest
    test 'show requires a signed in user' do
      poll = create_effective_poll!

      get effective_polls.poll_path(poll)
      assert_redirected_to new_user_session_path
    end

    test 'show redirects to ballot start path' do
      poll = create_effective_poll!
      user = sign_in()

      get effective_polls.poll_path(poll)
      assert_redirected_to effective_polls.poll_ballot_build_path(poll, :new, :start)
    end

    test 'show redirects to existing ballot path' do
      poll = create_effective_poll!
      user = sign_in()

      ballot = create_effective_ballot!(poll: poll, user: user)
      ballot.submit!

      get effective_polls.poll_path(poll)
      assert_redirected_to effective_polls.poll_ballot_build_path(poll, ballot, :start)
    end
  end
end
