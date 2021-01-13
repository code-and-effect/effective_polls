module Effective
  class PollsController < ApplicationController
    layout (EffectivePolls.layout.kind_of?(Hash) ? EffectivePolls.layout[:polls] : EffectivePolls.layout)

    before_action(:authenticate_user!) if defined?(Devise)
    include Effective::CrudController
  end
end
