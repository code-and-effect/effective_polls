require 'effective_resources'
require 'effective_datatables'
require 'effective_questions'
require 'effective_polls/engine'
require 'effective_polls/version'

module EffectivePolls

  def self.config_keys
    [
      :layout,
      :mailer, :parent_mailer, :deliver_method, :mailer_layout, :mailer_sender, :mailer_froms, :mailer_admin, :mailer_subject
    ]
  end

  include EffectiveGem

  def self.mailer_class
    mailer&.constantize || Effective::PollsMailer
  end

end
