module Effective
  class Poll < ActiveRecord::Base
    attr_accessor :skip_started_validation

    has_rich_text :all_steps_content
    has_rich_text :start_content
    has_rich_text :vote_content
    has_rich_text :submit_content
    has_rich_text :complete_content

    has_many :poll_notifications, -> { order(:id) }, inverse_of: :poll, dependent: :destroy
    accepts_nested_attributes_for :poll_notifications, allow_destroy: true

    has_many :poll_questions, -> { order(:position) }, inverse_of: :poll, dependent: :destroy
    accepts_nested_attributes_for :poll_questions, allow_destroy: true

    has_many :ballots
    has_many :ballot_responses

    # For the poll_results screens
    has_many :completed_ballots, -> { Effective::Ballot.completed }, class_name: 'Effective::Ballot'
    has_many :completed_ballot_responses, -> { where(ballot: Effective::Ballot.completed) }, class_name: 'Effective::BallotResponse'

    acts_as_tokened

    AUDIENCES = ['All Users', 'Individual Users', 'Selected Users']

    effective_resource do
      # Acts as tokened
      token                  :string, permitted: false

      title         :string

      start_at      :datetime
      end_at        :datetime

      audience            :string
      audience_scope      :text       # An Array of user_ids or named scopes on the User model

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
    scope :editable, -> { upcoming }

    scope :upcoming, -> { where('start_at > ?', Time.zone.now) }
    scope :available, -> { where('start_at <= ? AND (end_at > ? OR end_at IS NULL)', Time.zone.now, Time.zone.now) }
    scope :completed, -> { where('end_at < ?', Time.zone.now) }

    validates :title, presence: true
    validates :start_at, presence: true

    validates :audience, inclusion: { in: AUDIENCES }
    validates :audience_scope, presence: true, unless: -> { audience == 'All Users' }

    validate(if: -> { started? }, unless: -> { skip_started_validation }) do
      self.errors.add(:base, 'has already started. a poll cannot be changed after it has started.')
    end

    validate(if: -> { start_at.present? && !started? }, unless: -> { skip_started_validation }) do
      self.errors.add(:start_at, 'must be a future date') if start_at < Time.zone.now
    end

    validate(if: -> { start_at.present? && end_at.present? }) do
      self.errors.add(:end_at, 'must be after the start date') unless end_at > start_at
    end

    def to_s
      title.presence || 'New Poll'
    end

    def available_for?(user)
      raise('expected a user') unless user.kind_of?(User)
      available? && users.include?(user)
    end

    def users
      case audience
      when 'All Users'
        User.all
      when 'Individual Users'
        User.where(id: audience_scope)
      when 'Selected Users'
        collection = User.none
        audience_scope.each { |scope| collection = collection.or(User.send(scope)) }
        collection
      else
        raise('unexpected audience')
      end
    end

    def emails(exclude_completed: false)
      if exclude_completed
        users.where.not(id: completed_ballots.select('user_id as id')).pluck(:email)
      else
        users.pluck(:email)
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
