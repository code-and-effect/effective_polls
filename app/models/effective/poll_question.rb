module Effective
  class PollQuestion < ActiveRecord::Base
    belongs_to :poll

    has_many :poll_question_options, -> { order(:position) }, inverse_of: :poll_question, dependent: :delete_all
    accepts_nested_attributes_for :poll_question_options, reject_if: :all_blank, allow_destroy: true

    has_rich_text :body
    log_changes(to: :poll) if respond_to?(:log_changes)

    CATEGORIES = [
      'Choose one',   # Radios
      'Select all that apply', # Checks
      'Select upto 1',
      'Select upto 2',
      'Select upto 3',
      'Select upto 4',
      'Select upto 5',
      'Date',         # Date Field
      'Email',        # Email Field
      'Number',       # Numeric Field
      'Long Answer',  # Text Area
      'Short Answer', # Text Field
      'Upload File'   # File field
    ]

    WITH_OPTIONS_CATEGORIES = [
      'Choose one',   # Radios
      'Select all that apply', # Checks
      'Select upto 1',
      'Select upto 2',
      'Select upto 3',
      'Select upto 4',
      'Select upto 5'
    ]

    effective_resource do
      title         :string
      category      :string
      required      :boolean

      position      :integer

      timestamps
    end

    before_validation(if: -> { poll.present? }) do
      self.position ||= (poll.poll_questions.map { |obj| obj.position }.compact.max || -1) + 1
    end

    scope :deep, -> { with_rich_text_body_and_embeds.includes(:poll_question_options) }
    scope :sorted, -> { order(:position) }

    validates :title, presence: true
    validates :category, presence: true, inclusion: { in: CATEGORIES }
    validates :position, presence: true
    validates :poll_question_options, presence: true, if: -> { poll_question_option? }

    # Create choose_one? and select_all_that_apply? methods for each category
    CATEGORIES.each do |category|
      define_method(category.parameterize.underscore + '?') { self.category == category }
    end

    def to_s
      title.presence || 'New Poll Question'
    end

    def poll_question_option?
      WITH_OPTIONS_CATEGORIES.include?(category)
    end

    def category_partial
      category.to_s.parameterize.underscore
    end

  end
end
