EffectivePolls.setup do |config|
  # Layout Settings
  # Configure the Layout per controller, or all at once
  config.layout = {
    polls: 'application',
    admin: 'admin'
  }

  # Audience Scope Collection
  #
  # When creating a new poll, an Array of User scopes can be provided
  # The User model must respond to these
  #
  # config.audience_user_scopes = [:all, :registered]
  # config.audience_user_scopes = [['All Users', :all], ['Registered Users', :registered]]
  #
  config.audience_user_scopes = [['All Users', :all]]

  # Will work with effective_email_templates gem:
  # - The poll notifications email content will be preopulated based off the template
  # - Uses a EmailTemplatesMailer mailer instead of ActionMailer::Base
  config.use_effective_email_templates = true

end
