module Effective
  class BallotsController < ApplicationController
    layout (EffectivePolls.layout.kind_of?(Hash) ? EffectivePolls.layout[:polls] : EffectivePolls.layout)

    before_action(:authenticate_user!) if defined?(Devise)
    include Effective::WizardController

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
