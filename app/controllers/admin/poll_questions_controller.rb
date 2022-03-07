module Admin
  class PollQuestionsController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_polls) }

    include Effective::CrudController

    def permitted_params
      params.require(:effective_poll_question).permit!
    end

  end
end
