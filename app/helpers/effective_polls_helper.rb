module EffectivePollsHelper

  # Used on dashboard
  def polls_name_label
    et('effective_polls.name')
  end

  # Used by admin/polls form
  def effective_polls_audience_scope_collection(poll)
    klass = poll.try(:audience_class)
    raise('expected a poll with an audience_class') unless klass.try(:effective_polls_user?)

    resource = klass.new

    scopes = resource.poll_audience_scopes
    raise('expected poll audience scopes') unless scopes.kind_of?(Array)

    # Append the number of users in this scope
    scopes.map do |label, scope|
      relation = resource.poll_audience_scope(scope)
      raise("invalid poll_audience_scope for #{scope}") unless relation.kind_of?(ActiveRecord::Relation)

      ["#{label} (#{pluralize(relation.count, 'user')})", scope]
    end
  end

end
