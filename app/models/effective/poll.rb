module Effective
  class Poll < ActiveRecord::Base
    has_rich_text :body

    has_many :poll_questions, -> { order(:position) }, inverse_of: :poll, dependent: :destroy
    accepts_nested_attributes_for :poll_questions, allow_destroy: true

    has_many :ballots
    has_many :ballot_responses

    AUDIENCES = ['All Users', 'Individual Users', 'Selected Users']

    effective_resource do
      title         :string

      start_at      :datetime
      end_at        :datetime

      secret        :boolean

      audience            :string
      audience_scope      :text       # An Array of user_ids or named scopes on the User model

      timestamps
    end

    serialize :audience_scope, Array

    scope :deep, -> { with_rich_text_body_and_embeds.includes(poll_questions: :poll_question_options) }

    scope :started, -> { where('start_at >= ?', Time.zone.now) }
    scope :editable, -> { where('start_at < ?', Time.zone.now) }

    validates :title, presence: true
    validates :start_at, presence: true
    validates :end_at, presence: true

    validates :audience, inclusion: { in: AUDIENCES }
    validates :audience_scope, presence: true, unless: -> { audience == 'All Users' }

    validate(if: -> { started? }) do
      self.errors.add(:base, 'has already started. a poll cannot be changed after it has started.')
    end

    validate(if: -> { start_at.present? && !started? }) do
      self.errors.add(:start_at, 'must be a future date') if start_at < Time.zone.now
    end

    validate(if: -> { start_at.present? && end_at.present? }) do
      self.errors.add(:end_at, 'must be after the start date') unless end_at > start_at
    end

    def to_s
      title.presence || 'New Poll'
    end

    def started?
      start_at_was.present? && Time.zone.now > start_at_was
    end

    def audience_scope
      Array(super) - [nil, '']
    end

  end
end
