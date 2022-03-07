require 'effective_resources'
require 'effective_datatables'
require 'effective_polls/engine'
require 'effective_polls/version'

module EffectivePolls

  def self.config_keys
    [
      :polls_table_name, :poll_notifications_table_name, :poll_questions_table_name, :poll_question_options_table_name,
      :ballots_table_name, :ballot_responses_table_name, :ballot_response_options_table_name,
      :layout, :audience_user_scopes,
      :mailer, :parent_mailer, :deliver_method, :mailer_layout, :mailer_sender, :mailer_admin, :mailer_subject, :use_effective_email_templates
    ]
  end

  include EffectiveGem

  def self.mailer_class
    mailer&.constantize || Effective::PollsMailer
  end

end
