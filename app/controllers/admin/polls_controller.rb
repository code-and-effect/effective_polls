module Admin
  class PollsController < ApplicationController
    layout (EffectivePolls.layout.kind_of?(Hash) ? EffectivePolls.layout[:admin] : EffectivePolls.layout)

    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectivePolls.authorize!(self, :admin, :effective_polls) }

    include Effective::CrudController

    def permitted_params
      params.require(:effective_poll).permit!
    end

  end
end
