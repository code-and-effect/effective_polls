module Effective
  class PollsController < ApplicationController
    include Effective::CrudController

    layout (EffectivePolls.layout.kind_of?(Hash) ? EffectivePolls.layout[:polls] : EffectivePolls.layout)

    before_action(:authenticate_user!) if defined?(Devise)
  end
end
