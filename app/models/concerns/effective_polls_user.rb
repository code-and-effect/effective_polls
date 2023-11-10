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
  end

  def default_poll_audience_scopes
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

    if self.class.try(:effective_committees_user?)
      scopes += Effective::Committee.sorted.map do |committee|
        ["All #{committee} committee members", "with_committee_id_#{committee.id}"]
      end
    end

    if self.class.try(:acts_as_role_restricted?)
      scopes += EffectiveRoles.roles.map do |role|
        ["All #{role} role users", "with_role_id_#{role}"]
      end
    end

    scopes
  end

  # Turns the given audience_scope value into the actual ActiveRecord::Relation scope
  def poll_audience_scope(value)
    collection = self.class.respond_to?(:unarchived) ? self.class.unarchived : self.class

    # Parse the value
    name, id = value.to_s.split('_id_')

    case name.try(:to_sym)
    when :members_with_category
      return collection.members_with_category(EffectiveMemberships.Category.find_by_id(id))
    when :with_committee
      return collection.with_committee(Effective::Committee.find_by_id(id))
    when :with_role
      return collection.with_role(id)
    end

    # Otherwise we don't know what this scope is
    raise("unknown poll_audience_scope for #{value}. Expected #{self.class.name} to have a scope named #{value}") unless collection.respond_to?(value) 

    # If we respond to the fill value, call it
    collection.send(value) 
  end

  def available_polls
    Effective::Poll.available.select { |poll| poll.available_for?(self) }
  end

end
