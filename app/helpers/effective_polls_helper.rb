module EffectivePollsHelper

  # Used by admin/polls form
  def effective_polls_audience_scope_collection
    # Normalize the collection into [[label, value], [label, value]]
    scopes = Array(EffectivePolls.audience_user_scopes).map do |key, value|
      (key.present? && value.present?) ? [key, value] : [key.to_s.titleize, key]
    end

    # Makes sure the User model responds to all values
    scopes.each do |_, scope|
      unless defined?(User) && User.respond_to?(scope)
        raise("invalid effective_polls config.audience_user_scopes value. Your user model must respond to the scope User.#{scope}")
      end
    end

    # Append the number of users in this scope
    scopes.map! do |label, scope|
      ["#{label} (#{pluralize(User.send(scope).count, 'user')})", scope]
    end
  end

end
