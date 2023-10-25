module Admin
  class PollsController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_polls) }

    include Effective::CrudController

    on :save, only: :create, redirect: :edit

    def permitted_params
      params.require(:effective_poll).permit!
    end

  end
end
