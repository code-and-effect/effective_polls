module Effective
  class BallotsController < ApplicationController
    layout (EffectivePolls.layout.kind_of?(Hash) ? EffectivePolls.layout[:polls] : EffectivePolls.layout)

    before_action(:authenticate_user!) if defined?(Devise)
    include Effective::WizardController

    # Redirect to their in-progress ballot or root path when they click an incorrect poll link
    before_action(only: [:show, :new]) do
      existing = Effective::Ballot.where(poll: params[:poll_id]).where.not(id: resource).first

      if existing&.completed?
        flash[:danger] = 'You have already completed a ballot for this poll.'
        redirect_to(root_path)
      elsif existing.present?
        next_step = Effective::Ballot::WIZARD_STEPS.keys.reverse.find { |step| existing.can_visit_step?(step) } || :start
        flash[:success] = "You have been redirected to the #{resource_wizard_step_title(next_step)} step."

        redirect_to effective_polls.poll_ballot_build_path(existing.poll, existing, next_step)
      end
    end

    resource_scope do
      poll = Effective::Poll.find(params[:poll_id])
      Effective::Ballot.deep.where(poll: poll, user: current_user)
    end

    def permitted_params
      case step
      when :start
        params.require(:effective_ballot).permit(:current_step)
      when :vote
        params.require(:effective_ballot).permit(:current_step, ballot_responses_attributes: [
          :id, :poll_id, :poll_question_id,
          :date, :email, :number, :long_answer, :short_answer, :upload_file,
          :poll_question_option_ids, poll_question_option_ids: []
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
