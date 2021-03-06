EffectivePolls.setup do |config|
  config.polls_table_name = :polls
  config.poll_notifications_table_name = :poll_notifications
  config.poll_questions_table_name = :poll_questions
  config.poll_question_options_table_name = :poll_question_options
  config.ballots_table_name = :ballots
  config.ballot_responses_table_name = :ballot_responses
  config.ballot_response_options_table_name = :ballot_response_options

  # Authorization Method
  #
  # This method is called by all controller actions with the appropriate action and resource
  # If it raises an exception or returns false, an Effective::AccessDenied Error will be raised
  #
  # Use via Proc:
  # Proc.new { |controller, action, resource| authorize!(action, resource) }       # CanCan
  # Proc.new { |controller, action, resource| can?(action, resource) }             # CanCan with skip_authorization_check
  # Proc.new { |controller, action, resource| authorize "#{action}?", resource }   # Pundit
  # Proc.new { |controller, action, resource| current_user.is?(:admin) }           # Custom logic
  #
  # Use via Boolean:
  # config.authorization_method = true  # Always authorized
  # config.authorization_method = false # Always unauthorized
  #
  # Use via Method (probably in your application_controller.rb):
  # config.authorization_method = :my_authorization_method
  # def my_authorization_method(resource, action)
  #   true
  # end
  config.authorization_method = Proc.new { |controller, action, resource| authorize!(action, resource) }

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

  # Notifications Mailer Settings
  #
  # Schedule rake effective_polls:notify to run every 10 minutes
  # to send out email poll notifications
  #
  config.mailer = {
    layout: 'effective_polls_mailer_layout',
    default_from: 'no-reply@example.com'
  }

  # Will work with effective_email_templates gem:
  # - The poll notifications email content will be preopulated based off the template
  # - Uses a EmailTemplatesMailer mailer instead of ActionMailer::Base
  config.use_effective_email_templates = false

end
