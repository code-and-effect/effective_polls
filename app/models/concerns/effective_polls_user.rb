# EffectivePollsUser
#
# Mark your user model with effective_polls_user to get all the includes

module EffectivePollsUser
  extend ActiveSupport::Concern

  module Base
    def effective_polls_user
      include ::EffectivePollsUser
    end
  end

  module ClassMethods
    def effective_polls_user?; true; end
  end

  included do
    has_many :ballots, -> { Effective::Ballot.sorted }, inverse_of: :user, as: :user, class_name: 'Effective::Ballot'
  end

  # { active: nil, inactive: nil, with_first_name: :string, not_in_good_standing: :boolean }
  def pollable_scopes
    {}
  end

end
