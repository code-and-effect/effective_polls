module Effective
  class Poll < ActiveRecord::Base
    acts_as_tokened

    has_many :poll_notifications, -> { order(:id) }, inverse_of: :poll, dependent: :destroy
    accepts_nested_attributes_for :poll_notifications, allow_destroy: true

    has_many :poll_questions, -> { order(:position) }, inverse_of: :poll, dependent: :destroy
    accepts_nested_attributes_for :poll_questions, allow_destroy: true

    has_many :ballots
    has_many :ballot_responses

    # For the poll_results screens
    has_many :completed_ballots, -> { Effective::Ballot.completed }, class_name: 'Effective::Ballot'
    has_many :completed_ballot_responses, -> { where(ballot: Effective::Ballot.completed) }, class_name: 'Effective::BallotResponse'

    has_many_rich_texts

    # rich_text_all_steps_content
    # rich_text_start_content
    # rich_text_vote_content
    # rich_text_submit_content
    # rich_text_complete_content

    if respond_to?(:log_changes)
      log_changes(except: [:ballots, :ballot_responses, :completed_ballots, :completed_ballot_responses])
    end

    AUDIENCES = ['All Users', 'Individual Users', 'Selected Users']

    effective_resource do
      # Acts as tokened
      token         :string, permitted: false

      title         :string

      start_at      :datetime
      end_at        :datetime

      audience              :string
      audience_class_name   :string
      audience_scope        :text       # An Array of user_ids or named scopes on the User model

      timestamps
    end

    serialize :audience_scope, Array

    scope :deep, -> {
      includes(poll_questions: :poll_question_options)
      .with_rich_text_all_steps_content
      .with_rich_text_start_content
      .with_rich_text_vote_content
      .with_rich_text_submit_content
      .with_rich_text_complete_content
    }

    scope :deep_results, -> {
      includes(poll_questions: :poll_question_options)
      .includes(ballots: [ballot_responses: [:poll, :poll_question, :poll_question_options]])
    }

    scope :sorted, -> { order(:start_at) }

    scope :upcoming, -> { where('start_at > ?', Time.zone.now) }
    scope :available, -> { where('start_at <= ? AND (end_at > ? OR end_at IS NULL)', Time.zone.now, Time.zone.now) }
    scope :completed, -> { where('end_at < ?', Time.zone.now) }

    validates :title, presence: true
    validates :start_at, presence: true

    validates :audience, inclusion: { in: AUDIENCES }
    validates :audience_class_name, presence: true

    validates :audience_scope, presence: true, unless: -> { audience == 'All Users' }

    validate(if: -> { start_at.present? && end_at.present? }) do
      self.errors.add(:end_at, 'must be after the start date') unless end_at > start_at
    end

    def to_s
      title.presence || 'New Poll'
    end

    def available_for?(user)
      raise('expected an effective_polls_user') unless user.class.try(:effective_polls_user?)
      available? && users.include?(user)
    end

    def audience_class
      klass = audience_class_name.safe_constantize
      raise('expected an effective_polls_user klass') unless klass.try(:effective_polls_user?)
      klass
    end

    def users(except_completed: false)
      klass = audience_class()

      users = case audience
      when 'All Users'
        klass.all
      when 'Individual Users'
        klass.where(id: audience_scope)
      when 'Selected Users'
        collection = audience.none
        audience_scope.each { |scope| collection = collection.or(klass.send(scope)) }
        collection
      else
        raise('unexpected audience')
      end

      if except_completed
        users.where.not(id: completed_ballots.select('user_id as id'))
      else
        users
      end
    end

    def available?
      started? && !ended?
    end

    def started?
      start_at_was.present? && Time.zone.now >= start_at_was
    end

    def ended?
      end_at.present? && end_at < Time.zone.now
    end

    def available_date
      if start_at && end_at && start_at.to_date == end_at.to_date
        "#{start_at.strftime('%F at %H:%M')} to #{end_at.strftime('%H:%M')}"
      elsif start_at && end_at
        "#{start_at.strftime('%F at %H:%M')} to #{end_at.strftime('%F %H:%M')}"
      elsif start_at
        "#{start_at.strftime('%F at %H:%M')}"
      end
    end

    def audience_scope
      Array(super) - [nil, '']
    end

    # Returns all completed_ballot_responses
    def poll_results(poll_question: nil)
      return completed_ballot_responses if poll_question.nil?
      completed_ballot_responses.select { |br| br.poll_question_id == poll_question.id }
    end

  end
end
