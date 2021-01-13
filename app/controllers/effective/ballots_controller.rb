module Effective
  class BallotsController < ApplicationController
    layout (EffectivePolls.layout.kind_of?(Hash) ? EffectivePolls.layout[:polls] : EffectivePolls.layout)

    before_action(:authenticate_user!) if defined?(Devise)
    include Effective::WizardController

    resource_scope do
      Effective::Ballot.where(poll: params[:poll_id], user: current_user)
    end

  end
end
