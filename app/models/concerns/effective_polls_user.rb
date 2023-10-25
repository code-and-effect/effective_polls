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

  # The list of all available audience scopes for the Poll Selected Users
  def poll_audience_scopes
    scopes = [
      ['All Users', :all]
    ]

    if self.class.try(:effective_memberships_user?)
      scopes += [
        ['All members', :members],
        ['All removed members', :membership_removed],
        ['All members in good standing', :membership_in_good_standing],
        ['All members not in good standing', :membership_not_in_good_standing],
        ['All members renewed this period', :membership_renewed_this_period],
      ] 

      scopes += EffectiveMemberships.Category.sorted.map do |category|
        ["All #{category} members", "members_with_category_id_#{category.id}"]
      end
    end

    scopes
  end

  # Turns the given audience_scope value into the actual ActiveRecord::Relation scope
  def poll_audience_scope(value)
    collection = self.class.respond_to?(:unarchived) ? self.class.unarchived : self.class

    # If we respond to the fill value, call it
    return collection.send(value) if collection.respond_to?(value)

    # Parse the value
    name, id = value.to_s.split('_id_')

    case name.try(:to_sym)
    when :members_with_category
      collection.members_with_category(EffectiveMemberships.Category.find(id))
    else
      raise("unknown poll_audience_scope for #{value}")
    end
  end

  def available_polls
    Effective::Poll.available.select { |poll| poll.available_for?(self) }
  end

end
