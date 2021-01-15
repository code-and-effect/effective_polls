require 'test_helper'

module Effective
  class BallotsTest < ActionDispatch::IntegrationTest
    test 'requires a signed in user' do
      poll = create_effective_poll!

      get effective_polls.new_poll_ballot_path(poll)
      assert_redirected_to new_user_session_path
    end

    test 'new route redirects to start page' do
      poll = create_effective_poll!
      user = sign_in()

      get effective_polls.new_poll_ballot_path(poll)

      assert_redirected_to effective_polls.poll_ballot_build_path(poll, :new, :start)
      assert_redirected_to @controller.wizard_path(:start, ballot_id: :new)
    end

    test 'first step' do
      poll = create_effective_poll!
      user = sign_in()

      assert poll.available_for?(user)

      get effective_polls.poll_ballot_build_path(poll, :new, :start)

      assert_response :success
      assert_match "<form", @response.body

      assert_equal Effective::Ballot::WIZARD_STEPS.keys, @controller.wizard_steps
      assert_equal Effective::Ballot::WIZARD_STEPS.keys, @controller.resource_wizard_steps

      assert_equal Effective::Ballot::WIZARD_STEPS[:start], @controller.view_context.assigns['page_title']
      assert_equal Effective::Ballot::WIZARD_STEPS[:start], @controller.resource_wizard_step_title(:start)

      assert @controller.resource.kind_of?(Effective::Ballot)
      assert @controller.view_context.assigns['ballot'].kind_of?(Effective::Ballot)
      assert @controller.view_context.assigns['ballot'].new_record?

      assert @controller.view_context.resource.kind_of?(Effective::Ballot)
      assert @controller.view_context.resource.new_record?

      assert_equal :start, @controller.resource.current_step
    end

  end
end
