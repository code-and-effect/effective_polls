module Admin
  class PollNotificationsController < ApplicationController
    layout EffectivePolls.layout[:admin]

    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectivePolls.authorize!(self, :admin, :effective_polls) }

    include Effective::CrudController

    def permitted_params
      params.require(:effective_poll_notification).permit!
    end

  end
end
