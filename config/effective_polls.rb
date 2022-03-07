EffectivePolls.setup do |config|
  config.polls_table_name = :polls
  config.poll_notifications_table_name = :poll_notifications
  config.poll_questions_table_name = :poll_questions
  config.poll_question_options_table_name = :poll_question_options
  config.ballots_table_name = :ballots
  config.ballot_responses_table_name = :ballot_responses
  config.ballot_response_options_table_name = :ballot_response_options

  # Layout Settings
  # Configure the Layout per controller, or all at once
  # config.layout = { application: 'application', admin: 'admin' }

  # Audience Scope Collection
  #
  # When creating a new poll, an Array of User scopes can be provided
  # The User model must respond to these
  #
  # config.audience_user_scopes = [:all, :registered]
  # config.audience_user_scopes = [['All Users', :all], ['Registered Users', :registered]]
  #
  config.audience_user_scopes = [['All Users', :all]]

  # Notifications Mailer Settings
  #
  # Schedule rake effective_polls:notify to run every 10 minutes
  # to send out email poll notifications
  #
  # Please see config/initializers/effective_resources.rb for default effective_* gem mailer settings
  #
  # Configure the class responsible to send e-mails.
  # config.mailer = 'Effective::EventsMailer'
  #
  # Override effective_resource mailer defaults
  #
  # config.parent_mailer = nil      # The parent class responsible for sending emails
  # config.deliver_method = nil     # The deliver method, deliver_later or deliver_now
  # config.mailer_layout = nil      # Default mailer layout
  # config.mailer_sender = nil      # Default From value
  # config.mailer_admin = nil       # Default To value for Admin correspondence

  # Use effective email templates for event notifications
  config.use_effective_email_templates = true
end
