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

    test 'unavailable poll redirects to root path' do
      poll = create_effective_poll!
      poll.update_column(:end_at, Time.zone.now - 1.minute)

      user = sign_in()
      refute poll.available_for?(user)

      get effective_polls.poll_ballot_build_path(poll, :new, :start)
      assert_redirected_to root_path
      assert_equal 'This poll has ended', @controller.view_context.flash[:danger]
    end

    test 'existing ballot redirects' do
      poll = create_effective_poll!
      user = sign_in()

      ballot = create_effective_ballot!(poll: poll, user: user)
      ballot.wizard_steps[:start] = Time.zone.now
      ballot.save!

      get effective_polls.new_poll_ballot_path(poll)
      assert_redirected_to effective_polls.poll_ballot_build_path(poll, ballot, :vote)
    end

    test 'completed ballot redirects' do
      poll = create_effective_poll!
      user = sign_in()

      ballot = create_effective_ballot!(poll: poll, user: user)
      ballot.submit!

      get effective_polls.poll_ballot_build_path(poll, ballot, :vote)
      assert_redirected_to effective_polls.poll_ballot_build_path(poll, ballot, :complete)
    end

    test 'start step' do
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

    test 'save step valid' do
      poll = create_effective_poll!
      user = sign_in()

      assert poll.available_for?(user)
      put effective_polls.poll_ballot_build_path(poll, :new, :start), params: { effective_ballot: { current_step: 'start'} }

      assert_redirected_to effective_polls.poll_ballot_build_path(poll, Effective::Ballot.last, :vote)
      assert_equal 'Successfully saved ballot', flash[:success]

      assert @controller.resource.kind_of?(Effective::Ballot)
      assert @controller.resource.persisted?
    end

    test 'save step invalid' do
      poll = create_effective_poll!
      user = sign_in()
      assert poll.available_for?(user)

      # Create a duplicate
      ballot = create_effective_ballot!(poll: poll, user: user)
      put effective_polls.poll_ballot_build_path(poll, :new, :start), params: { effective_ballot: { current_step: 'start'} }

      assert_response :success
      assert_equal "Unable to save ballot: user ballot already exists for this poll", flash[:danger]
      assert_match "<form", @response.body

      assert @controller.resource.kind_of?(Effective::Ballot)
      assert @controller.view_context.assigns['ballot'].kind_of?(Effective::Ballot)
      assert @controller.view_context.assigns['ballot'].errors.present?
      assert_equal :start, @controller.resource.current_step
    end

  end
end
