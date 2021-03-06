require 'effective_resources'
require 'effective_datatables'
require 'effective_polls/engine'
require 'effective_polls/version'

module EffectivePolls
  mattr_accessor :polls_table_name
  mattr_accessor :poll_notifications_table_name
  mattr_accessor :poll_questions_table_name
  mattr_accessor :poll_question_options_table_name
  mattr_accessor :ballots_table_name
  mattr_accessor :ballot_responses_table_name
  mattr_accessor :ballot_response_options_table_name

  mattr_accessor :authorization_method

  mattr_accessor :layout

  mattr_accessor :audience_user_scopes

  # Hashes of configs
  mattr_accessor :use_effective_email_templates
  mattr_accessor :mailer

  def self.setup
    yield self
  end

  def self.authorized?(controller, action, resource)
    @_exceptions ||= [Effective::AccessDenied, (CanCan::AccessDenied if defined?(CanCan)), (Pundit::NotAuthorizedError if defined?(Pundit))].compact

    return !!authorization_method unless authorization_method.respond_to?(:call)
    controller = controller.controller if controller.respond_to?(:controller)

    begin
      !!(controller || self).instance_exec((controller || self), action, resource, &authorization_method)
    rescue *@_exceptions
      false
    end
  end

  def self.authorize!(controller, action, resource)
    raise Effective::AccessDenied.new('Access Denied', action, resource) unless authorized?(controller, action, resource)
  end

  def self.mailer_class
    if use_effective_email_templates
      require 'effective_email_templates'
      Effective::EmailTemplatesMailer
    else
      ActionMailer::Base
    end
  end

end
