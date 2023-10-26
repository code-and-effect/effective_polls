EffectivePolls.setup do |config|
  # Layout Settings
  # Configure the Layout per controller, or all at once
  config.layout = {
    polls: 'application',
    admin: 'admin'
  }

  # Will work with effective_email_templates gem
end
