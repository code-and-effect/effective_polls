module Effective
  class PollsController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)

    def show
      poll = Effective::Poll.find(params[:id])

      EffectiveResources.authorize!(self, :show, poll)

      ballot = Effective::Ballot.where(poll: poll, user: current_user).first

      if ballot.present?
        redirect_to effective_polls.poll_ballot_build_path(poll, ballot, ballot.next_step)
      else
        redirect_to effective_polls.poll_ballot_build_path(poll, :new, :start)
      end
    end
  end

end
