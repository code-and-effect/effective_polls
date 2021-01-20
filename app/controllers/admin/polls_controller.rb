module Admin
  class PollsController < ApplicationController
    layout EffectivePolls.layout[:admin]

    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectivePolls.authorize!(self, :admin, :effective_polls) }

    include Effective::CrudController

    def results
      @poll = Effective::Poll.find(params[:id])
      EffectivePolls.authorize!(self, :results, @poll)

      @datatable = Admin::EffectivePollResultsDatatable.new(poll_token: @poll.token)
      @page_title = "#{@poll} Results"
    end

    def permitted_params
      params.require(:effective_poll).permit!
    end

  end
end
