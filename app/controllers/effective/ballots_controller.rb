module Effective
  class BallotsController < ApplicationController
    include Effective::WizardController

    layout (EffectivePolls.layout.kind_of?(Hash) ? EffectivePolls.layout[:polls] : EffectivePolls.layout)

    before_action(:authenticate_user!) if defined?(Devise)
  end
end
