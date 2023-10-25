EffectivePolls.setup do |config|
  # Layout Settings
  # Configure the Layout per controller, or all at once
  config.layout = {
    polls: 'application',
    admin: 'admin'
  }

  # Will work with effective_email_templates gem:
  # - The poll notifications email content will be preopulated based off the template
  # - Uses a EmailTemplatesMailer mailer instead of ActionMailer::Base
  config.use_effective_email_templates = true

end
