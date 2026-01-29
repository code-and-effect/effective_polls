module Effective
  class BallotsController < ApplicationController

    if defined?(Devise)
      before_action :authenticate_user!, unless: -> { action_name == 'new' || (action_name == 'show' && params[:id] == 'start') }
    end

    include Effective::WizardController

    resource_scope do
      poll = Effective::Poll.find(params[:poll_id])
      Effective::Ballot.deep.where(poll: poll, user: current_user)
    end

    # Enforce one ballot per user. Redirect them to an existing ballot for this poll.
    before_action(only: [:new, :show]) do
      poll = Effective::Poll.find(params[:poll_id])
      existing = Effective::Ballot.where(poll: poll, user: current_user).where.not(id: resource).first

      if existing&.completed?
        flash[:danger] = 'You have already completed a ballot for this poll.'
        redirect_to(root_path)
      elsif existing.present?
        flash[:success] = "You have been redirected to the #{resource_wizard_step_title(existing, existing.next_step)} step."
        redirect_to effective_polls.poll_ballot_build_path(existing.poll, existing, existing.next_step)
      end
    end

    # Enforce poll availability
    before_action(only: [:show, :update]) do
      poll = resource.poll

      unless poll.available_for?(current_user)
        flash[:danger] = begin
          if poll.ended?
            'This poll has ended'
          elsif !poll.started?
            'This poll has not yet started'
          elsif !poll.users.include?(current_user)
            'This poll is not available to you'
          else
            'This poll is unavailable'
          end
        end

        redirect_to(root_path)
      end
    end

    private

    def permitted_params
      case step
      when :start
        params.require(:effective_ballot).permit(:current_step)
      when :vote
        params.require(:effective_ballot).permit(:current_step, responses_attributes: [
          :id, :questionable_type, :questionable_id, :question_id,
          :date, :email, :number, :long_answer, :short_answer, :upload_file, :_destroy,
          :question_option_ids, question_option_ids: []
        ])
      when :submit
        params.require(:effective_ballot).permit(:current_step)
      when :complete
        raise('unexpected post to complete')
      else
        raise('unexpected step')
      end
    end

  end
end
